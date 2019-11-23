//
//  LoadingImage.swift
//  MyTubePlayer
//
//  Created by Lars Stegman on 04/08/2019.
//  Copyright © 2019 Stegman. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

final class ImageLoader: ObservableObject {
    @Published private(set) var image: Image? = nil
    @Published private(set) var status: LoadingStatus = .uninit

    private let loadable: ImageLoadable
    private var cancellable: AnyCancellable?

    init(loadable: ImageLoadable) {
        self.loadable = loadable
    }

    deinit {
        cancellable?.cancel()
    }

    func load() {
        guard status != .finished else {
            return
        }

        self.status = .loading
        cancellable = loadable
            .loadImage()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        self.status = self.image == nil ? .cancelled : .finished
                    case .failure(let err):
                        self.status = .failure(err)
                    }
                },
                receiveValue: { [weak self] image in
                    self?.image = image
                }
            )
    }

    func cancel() {
        cancellable?.cancel()
    }
}

struct ImagePlaceholder<V: View>: View {
    let center: () -> V
    init(@ViewBuilder center: @escaping () -> V) {
        self.center = center
    }

    var body: some View {
        center()
            .imageScale(.large)
            .flexible(axis: .all)
            .aspectRatio(16/9, contentMode: .fit)
    }
}

struct ImageLoadingView: View {
    @ObservedObject var imageLoader: ImageLoader

    init(image: ImageLoadable) {
        imageLoader = ImageLoader(loadable: image)
    }

    var body: some View {
        Group {
            if imageLoader.status == .finished {
                imageLoader.image!
                    .resizable()
            } else if imageLoader.status == .loading {
                ImagePlaceholder {
                    Spinner(isAnimating: true, style: .large)
                }
                .aspectRatio(16/9, contentMode: .fit)
            } else {
                ImagePlaceholder {
                    Image(systemName: "xmark.rectangle")
                }
                .aspectRatio(16/9, contentMode: .fit)
            }
        }
        .onAppear(perform: imageLoader.load)
        .onDisappear(perform: imageLoader.cancel)
    }
}

protocol ImageLoadable {
    func loadImage() -> AnyPublisher<Image, LoadingError>

    func equals(_ other: ImageLoadable) -> Bool
}

extension ImageLoadable where Self: Equatable {
    func equals(_ other: ImageLoadable) -> Bool {
        return other as? Self == self
    }
}


extension ImageLoadable {
    func any<T>() -> AnyImageLoadable<T> {
        return AnyImageLoadable<T>(self)
    }
}

struct AnyImageLoadable<WhenDecodedLoadable: ImageLoadable & Decodable>: ImageLoadable, Equatable, Decodable {
    private let loadable: ImageLoadable

    init(_ loadable: ImageLoadable) {
        self.loadable = loadable
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        loadable = try container.decode(WhenDecodedLoadable.self)
    }

    func loadImage() -> AnyPublisher<Image, LoadingError> {
        return loadable.loadImage()
    }

    static func ==(lhs: AnyImageLoadable, rhs: AnyImageLoadable) -> Bool {
        return lhs.loadable.equals(rhs.loadable)
    }
}

extension URL: ImageLoadable {
    func loadImage() -> AnyPublisher<Image, LoadingError> {
        URLSession
            .shared
            .dataTaskPublisher(for: self)
            .mapError { (_) -> LoadingError in
                return LoadingError.loadingFailed
            }
            .tryMap { data, _ in
                guard let image = UIImage(data: data) else {
                    throw LoadingError.decodingFailed
                }

                return Image(uiImage: image)
            }
            .mapError {
                return $0 as! LoadingError
            }
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .eraseToAnyPublisher()
    }
}

extension UIImage: ImageLoadable {
    func loadImage() -> AnyPublisher<Image, LoadingError> {
        return Just(Image(uiImage: self))
            .setFailureType(to: LoadingError.self)
            .eraseToAnyPublisher()
    }
}

extension Image: ImageLoadable {
    func loadImage() -> AnyPublisher<Image, LoadingError> {
        return Just(self)
            .setFailureType(to: LoadingError.self)
            .eraseToAnyPublisher()
    }
}

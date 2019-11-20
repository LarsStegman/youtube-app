//
//  VideoStreamFetcher.swift
//  MyTubePlayer
//
//  Created by Lars Stegman on 21/10/2019.
//  Copyright © 2019 Stegman. All rights reserved.
//

import Foundation
import Combine

class YouTubeStreamFetcher: ObservableObject {
    private var session = URLSession(configuration: .ephemeral)

    static let `default` = YouTubeStreamFetcher()

    static var formats: [Int: VideoFormat] = {
        guard let path = Bundle.main.path(forResource: "video_formats", ofType: "json") else {
            fatalError("Unable to find video formats file")
        }

        do {
            let pathUrl = URL(fileURLWithPath: path)
            let data = try Data(contentsOf: pathUrl)
            let formats = try JSONDecoder().decode([VideoFormat].self, from: data)
            return Dictionary(values: formats, valueKey: \.id)
        } catch let e {
            print(e)
            fatalError("Unable to decode video formats")
        }
    }()

    static let videoFormatPreferredSort: SortDescriptor<VideoFormat> = .multiple([
        .ascending(on: \.codec),
        .ascending(on: \.resolution.height)
    ])

    @Published private(set) var videoSource: VideoPlaybackData? = nil
    private var sourceFetcher: AnyCancellable? = nil

    func load(videoId: String) {
        self.videoSource = nil
        self.sourceFetcher?.cancel()
        self.sourceFetcher = self.playbackData(videoId: videoId)
            .ignoreError()
            .sink(receiveValue: {
                self.videoSource = $0
            })
    }


    static var preferredStreamFormatOrdering: [VideoFormat] {
        get {
            if let preferences = (UserDefaults.standard.array(forKey: "video_format_preferences") as? [Int])?
                .compactMap({ self.formats[$0] }), !preferences.isEmpty {
                return preferences
            } else {
                return self.formats.values.sorted(by: self.videoFormatPreferredSort)
            }
        }
        set {
            UserDefaults.standard.set(newValue.map({ $0.id }), forKey: "video_format_preferences")
        }
    }

    func playbackData(videoId: String) -> AnyPublisher<VideoPlaybackData, Error> {
        let source = URL(string: "https://www.youtube.com/get_video_info?video_id=\(videoId)")!
        return self.session.dataTaskPublisher(for: source)
            .mapError({ _ in LoadingError.loadingFailed })
            .tryMap { data, response in
                guard let d = String(data: data, encoding: .utf8) else {
                    throw LoadingError.decodingFailed
                }

                return d
            }
            .map {
                VideoPlaybackData(videoId: videoId, streams: self.streams(from: self.parseUrlEncoded(data: $0)))
            }
            .eraseToAnyPublisher()
    }

    private func streams(from info: [String: String]) -> [VideoFormat: URL] {
        let streamData = self.getStreamUrls(from: info)
        let rawStreams = streamData.map({ self.parseUrlEncoded(data: $0) })
        let streams = self.createQualityUrlMap(from: rawStreams)
        return streams
    }

    private func parseUrlEncoded(data: String) -> [String: String] {
        return data.split(separator: "&").reduce([String: String]()) { (r, s) -> [String: String] in
            let kv = s.split(separator: "=", maxSplits: 1, omittingEmptySubsequences: true)
            if kv.count < 2 {
                return r
            }

            var c = r
            let key = String(kv[0])
            let value = String(kv[1])
            c[key] = value
            return c
        }
    }

    private func createQualityUrlMap(from videoData: [[String: String]]) -> [VideoFormat : URL] {
        return videoData.reduce([VideoFormat: URL]()) { (r, d) -> [VideoFormat: URL] in
            guard let keyVal = d["itag"]?.removingPercentEncoding,
                let key = NumberFormatter().number(from: keyVal)?.intValue,
                let value = d["url"]?.removingPercentEncoding,
                let url = URL(string: value),
                let format =  YouTubeStreamFetcher.formats[key] else {
                    return r
            }


            var rc = r
            rc[format] = url
            return rc
        }
    }

    private func getStreamUrls(from videoData: [String: String]) -> [String] {
        let streams = videoData["url_encoded_fmt_stream_map"]?.removingPercentEncoding?.split(separator: ",").map({String($0)})
        let adaptiveStreams = videoData["adaptive_fmts"]?.removingPercentEncoding?.split(separator: ",").map({String($0)})

        return (streams ?? []) + (adaptiveStreams ?? [])
    }
}


extension YouTubeStreamFetcher {
    func load(video: Video) {
        self.load(videoId: video.id)
    }

    func load(url: String) {
        guard let url = URL(string: url) else {
            return
        }

        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
            let vidId = components.queryItems?.first(where: {$0.name == "v"})?.value else {
            return
        }

        self.load(videoId: vidId)
    }
}


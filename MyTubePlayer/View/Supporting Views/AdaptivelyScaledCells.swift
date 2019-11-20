import SwiftUI



struct WideScreenImage: View {
    var body: some View {
        Rectangle()
            .foregroundColor(Color.green)
            .aspectRatio(16/9, contentMode: .fill)
    }
}

struct AdaptiveList: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .center) {
                ForEach(0..<10) { _ in
                    AdaptivelyScaledCell()
                        .fixedSize(horizontal: false, vertical: true)
                        .background(Color.yellow)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
        .background(Color.blue)
    }
}

struct AdaptivelyScaledCell: View {
    @State var isLoaded: Bool = true
    var body: some View {
        VStack(spacing: 0) {
            if self.isLoaded {
                WideScreenImage()
            } else {
                ZStack {
                    Rectangle()
                        .aspectRatio(4/3, contentMode: .fill)

                    Image(systemName: "xmark.rectangle")
                        .imageScale(.large)
                }
                .background(Color.gray)
            }

            HStack {
                VStack(alignment: .leading) {
                    Text("Hello World!")
                        .font(.headline)
                    Text("How are you?")
                        .font(.subheadline)
                }
                Spacer()
            }
            .padding()
        }.onTapGesture(perform: {
            withAnimation {
                self.isLoaded.toggle()
            }
        })
    }
}

struct AdaptivelyList_Previews: PreviewProvider {
    static var previews: some View {
        AdaptiveList()
    }
}

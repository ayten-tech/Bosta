import SwiftUI

struct AlbumView: View {
    let album: Album
    @StateObject private var viewModel = AlbumController()

    var body: some View {
        VStack {
            TextField("Search", text: $viewModel.searchQuery)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                    ForEach(viewModel.filteredPhotos) { photo in
                        VStack {
                            AsyncImage(url: URL(string: photo.thumbnailUrl))
                                .frame(width: 100, height: 100)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            Text(photo.title)
                                .font(.caption)
                                .lineLimit(1)
                        }
                    }
                }
            }
        }
        .navigationTitle(album.title) // Set the title of the navigation bar
        .onAppear { viewModel.fetchPhotos(albumId: album.id) }
    }
}

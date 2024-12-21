import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileController()

    var body: some View {
        NavigationStack {
            VStack {
                Text(viewModel.user?.name ?? "Loading...")
                    .font(.largeTitle)
                    .padding()
                
                // Display address if available
                Text(viewModel.user?.addressDescription ?? "Loading address...")
                    .font(.subheadline)

                // List of albums
                List(viewModel.albums) { album in
                    NavigationLink(destination: AlbumView(album: album)) {
                        Text(album.title)
                    }
                }
            }
            .onAppear { viewModel.fetchuser() }
        }
    }
}
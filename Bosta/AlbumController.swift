import CombineMoya
import Foundation
import Combine
import CombineCocoa
import Moya

class AlbumController: ObservableObject {
    @Published var photos: [Photo] = []
    @Published var searchQuery = ""
    private let provider = MoyaProvider<APIService>()
    private var cancellables = Set<AnyCancellable>()
    //this property works as the following if searchQuery is empty returns all photos , on the other hand if search query contains a value only photos with these value are returned in the array
    var filteredPhotos: [Photo]{
        searchQuery.isEmpty ? photos: photos.filter{ $0.title.contains(searchQuery)}
    }
    
    func fetchPhotos(albumId: Int){
        provider.requestPublisher(.photos(albumId: albumId))
            .map([Photo].self)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion{
                case.finished:
                    print("Successfully fetched photos for album \(albumId).")
                case.failure(let error):
//                    self?.errorMessage = error.localizedDescription
                    print("Error fetching photos: \(error.localizedDescription)")
                }
                
                
            }, receiveValue: { [weak self] photos in
                self?.photos = photos
                
            })
            .store(in: &cancellables)
    }
}

struct Photo: Codable, Identifiable{
    let id: Int
    let title: String
    let url: String
    let thumbnailUrl: String
}



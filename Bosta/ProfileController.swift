import CombineMoya
import Foundation
import Combine
import CombineCocoa
import Moya



class ProfileController: ObservableObject {
    //SWIFT UI user componenet(varialbe) is of custom type (struct) User
    @Published var user: User?
    @Published var albums: [Album] = []
    private var cancellables = Set<AnyCancellable>()
    //instance of MoyaProvider to handle requests of enum defined APIService
    private let provider = MoyaProvider<APIService>()
    func fetchuser() {
        provider.requestPublisher(.users) // Call .users case from APIService
            .map([User].self) // Map response to an array of User objects
            .compactMap { $0.first } // Extract the first user from the array
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break // No further action needed on success
                case .failure(let error):
                    print("Error fetching user: \(error.localizedDescription)") // Handle the error
                }
            }, receiveValue: { [weak self] user in
                self?.user = user // Update the user property in the view model
                // If the user is valid, fetch albums for this user
                self?.fetchAlbums(userId: user.id)
                
            })
            .store(in: &cancellables) // Store the subscription in cancellables
    }

    
    func fetchAlbums(userId: Int){
        provider.requestPublisher(.albums(userId: userId))
            .map([Album].self) //decode json into array of albums
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Successfully fetched albums for user \(userId).")
                case .failure(let error):
                    print("Error fetching albums: \(error.localizedDescription)")
                }
                
            }, receiveValue: { [weak self] albums in
                self?.albums = albums // update the albums in UI VIEW
                
            })
            .store(in: &cancellables) //stores subscription
        
    }

    
}
struct User: Codable{
    let id : Int
    let name: String
    let address: Address
    var addressDescription: String {
            "\(address.street), \(address.city)"
        }
}
struct Address: Codable{
    let street: String
    let city: String
}
struct Album: Codable, Identifiable{
    let id: Int
    let title: String
}


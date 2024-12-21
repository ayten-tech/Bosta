import Combine
import Foundation
import CombineCocoa
import Moya

//define endpoints ,which are (fetching users , fetching albums ,and fetching photos)
enum APIService {
    case users
    case albums(userId: Int)
    case photos(albumId: Int)
}

extension APIService: TargetType {
    
    //means no authentication(set as false) required
    var headers: [String : String]? {
        nil
    }
    
//    var sampleData: Data {Data()} //already defined in parent class
   
    //! forces means always valid
    //the base URL for all requests in this service is set to
    var baseURL: URL { URL(string: "https://jsonplaceholder.typicode.com")! }
   
    var path: String {
        switch self {
        case .users: return "/users"
        case .albums: return "/albums"
        case . photos: return "/photos"
            
        }
    }
    var method: Moya.Method{ .get } //all http method requests use GET method
    var task: Task{
        switch self{
        case.albums(let userId): return.requestParameters(parameters: ["userId": userId], encoding: URLEncoding.queryString)
        case.photos(let albumId): return.requestParameters(parameters: ["albumId" : albumId], encoding: URLEncoding.queryString)
            // default case here is users
        default: return.requestPlain
        }
    }
   
    
}

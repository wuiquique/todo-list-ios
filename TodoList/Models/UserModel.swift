import Foundation

struct UserModel: Decodable, Identifiable {
    var id: Int
    var name: String
    var username: String
}

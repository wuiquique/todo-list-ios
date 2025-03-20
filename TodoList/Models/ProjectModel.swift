import Foundation

struct ProjectModel: Decodable, Identifiable {
    var id: Int
    var name: String
    var userId: Int
    var task_total: Int
    var task_completed: Int
}

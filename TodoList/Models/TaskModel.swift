import Foundation

struct TaskModel: Decodable, Identifiable {
    var id: Int
    var title: String
    var isCompleted: Bool
    var due: String
    var projectId: Int
}

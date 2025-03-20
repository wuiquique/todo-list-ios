import Foundation

@MainActor
class TaskViewModel: ObservableObject {
    
    @Published var tasks: [TaskModel] = []
    
    func fetchTasks(projectId: Int) async {
        let urlString = "http://localhost:8000/tasks/\(projectId)"
        
        do {
            let tasks: [TaskModel] = try await NetworkUtils.fetchData(from: urlString, method: .GET)
            DispatchQueue.main.async {
                self.tasks = tasks
            }
        } catch {
            print("Error fetching tasks: \(error.localizedDescription)")
        }
    }
    
    struct DeleteResponse: Codable {
        let message: String
    }
    
    func deleteTask(id: Int, projectId: Int) async {
        let urlString = "http://localhost:8000/tasks/\(id)"
        
        do {
            let _: DeleteResponse = try await NetworkUtils.fetchData(from: urlString, method: .DELETE)
            await self.fetchTasks(projectId: projectId)
        } catch {
            print("Error deleting task: \(error.localizedDescription)")
        }
    }
    
    func createTask(title: String, isCompleted: Bool = false, due: Date, projectId: Int) async {
        let urlString = "http://localhost:8000/tasks"
        
        let postBody: [String: Any] = [
            "title": title,
            "isCompleted": isCompleted,
            "due": DateUtils.formatDate(due),
            "projectId": projectId
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: postBody)
            
            let _: TaskModel = try await NetworkUtils.fetchData(from: urlString, method: .POST, body: jsonData)
            await self.fetchTasks(projectId: projectId)
        } catch {
            print("Error creating task: \(error.localizedDescription)")
        }
    }
    
    func toogleTask(id: Int, projectId: Int) async {
        let urlString = "http://localhost:8000/tasks/\(id)"
        
        do {
            let _: TaskModel = try await NetworkUtils.fetchData(from: urlString, method: .PATCH)
            await self.fetchTasks(projectId: projectId)
        } catch {
            print("Error toogling task: \(error.localizedDescription)")
        }
    }
}

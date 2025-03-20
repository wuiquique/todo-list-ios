import Foundation

@MainActor
class ProjectViewModel: ObservableObject {
    
    @Published var projects: [ProjectModel] = []
    
    func fetchProjects(userId: Int) async {
        let urlString = "http://localhost:8000/projects/\(userId)"
        
        do {
            let projects: [ProjectModel] = try await NetworkUtils.fetchData(from: urlString, method: .GET)
            DispatchQueue.main.async {
                self.projects = projects
            }
        } catch {
            print("Error fetching projects: \(error.localizedDescription)")
        }
    }
    
    struct StringResponse: Codable {
        let message: String
    }
    
    func deleteProject(projectId: Int, userId: Int) async {
        let urlString = "http://localhost:8000/projects/\(projectId)"
        
        do {
            let _: StringResponse = try await NetworkUtils.fetchData(from: urlString, method: .DELETE)
            await self.fetchProjects(userId: userId)
        } catch {
            print("Error deleting project: \(error.localizedDescription)")
        }
    }
    
    func createTask(title: String, isCompleted: Bool = false, due: Date, projectId: Int, userId: Int) async {
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
            await self.fetchProjects(userId: userId)
        } catch {
            print("Error creating task: \(error.localizedDescription)")
        }
    }
    
    func createProject(name: String, userId: Int) async {
        let urlString = "http://localhost:8000/projects"
        
        let postBody: [String: Any] = [
            "name": name,
            "userId": userId
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: postBody)
            
            let _: ProjectModel = try await NetworkUtils.fetchData(from: urlString, method: .POST, body: jsonData)
            await self.fetchProjects(userId: userId)
        } catch {
            print("Error creating project: \(error.localizedDescription)")
        }
    }
    
    func createTaskNewProyect(projectName: String, userId: Int, taskTitle: String, isCompleted: Bool = false, due: Date) async {
        let urlProjectString = "http://localhost:8000/projects"
        let urlTaskString = "http://localhost:8000/tasks"
        
        let postProjectBody: [String: Any] = [
            "name": projectName,
            "userId": userId
        ]
        
        do {
            let jsonDataProject = try JSONSerialization.data(withJSONObject: postProjectBody)
            
            let newProject: ProjectModel = try await NetworkUtils.fetchData(from: urlProjectString, method: .POST, body: jsonDataProject)
            
            let postTaskBody: [String: Any] = [
                "title": taskTitle,
                "isCompleted": isCompleted,
                "due": DateUtils.formatDate(due),
                "projectId": newProject.id
            ]
            
            do {
                let jsonDataTask = try JSONSerialization.data(withJSONObject: postTaskBody, options: [])
                
                let _: TaskModel = try await NetworkUtils.fetchData(from: urlTaskString, method: .POST, body: jsonDataTask)
                await self.fetchProjects(userId: userId)
            } catch {
                print("Error creating task: \(error.localizedDescription)")
            }
            
        } catch {
            print("Error creating project: \(error.localizedDescription)")
        }
    }
    
    func toggleAll(projectId: Int, isCompleted: Bool, userId: Int) async {
        let urlString = "http:/localhost:8000/tasks/\(projectId)/toggle"
        
        let postBody: [String: Any] = [
            "isCompleted": isCompleted
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: postBody)
            
            let _: StringResponse = try await NetworkUtils.fetchData(from: urlString, method: .PATCH, body: jsonData)
            await self.fetchProjects(userId: userId)
        } catch {
            print("Error toogling all tasks: \(error.localizedDescription)")
        }
    }
}

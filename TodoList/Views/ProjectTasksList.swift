import SwiftUI

struct ProjectTasksList: View {
    @Environment(\.presentationMode) var presentationMode
    
    let isDaily: Bool
    let id: Int
    
    @EnvironmentObject private var projectsViewModel: ProjectViewModel
    
    @StateObject private var taskViewModel: TaskViewModel = .init()
    
    private var project: ProjectModel? {
        projectsViewModel.projects.first(where: { $0.id == id })
    }
    
    @AppStorage("userId") var currentUserId: Int?
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .topLeading) {
                headerCard.padding(.bottom, 20).padding(.top, 80)
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "xmark")
                        .font(.headline)
                        .foregroundColor(.primary.opacity(0.9))
                        .background(
                            Circle()
                                .stroke(Color.primary.opacity(0.3), lineWidth: 1)
                                .frame(width: 48, height: 48)
                        )
                })
                .padding()
                .padding()
            }
            if taskViewModel.tasks.isEmpty {
                Text("No tasks found")
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .padding()
                Spacer()
            } else {
                List {
                    Section(content: {
                        EditButton().foregroundColor(Color(isDaily ? "Main" : "Accent"))
                        
                        ForEach(taskViewModel.tasks.filter { !$0.isCompleted }) { task in
                            TaskRow(title: task.title, isCompleted: task.isCompleted, id: task.id, projectId: id, due: task.due)
                        }
                        .onDelete {indexSet in deleteTask(indexSet: indexSet)}
                    }).listRowSeparator(.hidden)
                    Section("Completed (\(taskViewModel.tasks.filter(\.isCompleted).count))") {
                        ForEach(taskViewModel.tasks.filter(\.isCompleted)) { task in
                            TaskRow(title: task.title, isCompleted: task.isCompleted, id: task.id, projectId: id, due: task.due)
                        }
                    }.listRowSeparator(.hidden)   
                }
                .backgroundStyle(.opacity(0))
                .listStyle(PlainListStyle())
            }
        }
        .onAppear() {
            Task {
                await taskViewModel.fetchTasks(projectId: id)
            }
        }
        .environmentObject(taskViewModel)
    }
    
    var headerCard: some View {
        if isDaily {
            return AnyView(
                NewDailyTask(
                    total: project?.task_total ?? 0,
                    completed: project?.task_completed ?? 0,
                    id: id,
                    detailRequired: false,
                    createTask: { title, isCompleted, due, projectId in
                        Task {
                            await createTask(title: title, isCompleted: isCompleted, due: due, projectId: projectId)
                        }
                    }
                )
            )}
        else {
            return AnyView(
                NewProjectTask(
                    title: project?.name ?? "",
                    total: project?.task_total ?? 0,
                    completed: project?.task_completed ?? 0,
                    id: id,
                    createTask: { title, isCompleted, due, projectId in
                        Task {
                            await createTask(title: title, isCompleted: isCompleted, due: due, projectId: projectId)
                        }
                    },
                    inTasksView: true
                )
            )
        }
    }
}

extension ProjectTasksList {
    func createTask(title: String, isCompleted: Bool = false, due: Date, projectId: Int) async {
        Task {
            await taskViewModel.createTask(title: title, due: due, projectId: projectId)
        }
    }
    
    func deleteTask(indexSet: IndexSet) {
        for index in indexSet {
            let filteredTasks = taskViewModel.tasks.filter { !$0.isCompleted }
            
            guard index < filteredTasks.count else { continue }
            
            let task = taskViewModel.tasks.filter { !$0.isCompleted }[index]
            
            Task {
                await taskViewModel.deleteTask(id: task.id, projectId: id)
                await projectsViewModel.fetchProjects(userId: currentUserId ?? 0)
                
                DispatchQueue.main.async {
                    taskViewModel.tasks.removeAll { $0.id == task.id }
                }
            }
        }
    }
}

#Preview {
    ProjectTasksList(
        isDaily: false,
        id: 1
    )
}

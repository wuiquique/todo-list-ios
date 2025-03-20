import SwiftUI

struct Home: View {
    @AppStorage("userId") var currentUserId: Int?
    @AppStorage("name") var currentName: String?
    
    @State private var detailID: Int?
    @State private var showDetail: Bool = false
    @State private var showCreateProject: Bool = false
    
    @StateObject private var projectsViewModel: ProjectViewModel = .init()
    
    var body: some View {
        ZStack {
            ScrollView {
                LazyVStack {
                    Welcome(userName: currentName ?? "", projectsCount: projectsViewModel.projects.count)
                        .padding(.bottom, 20)
                    
                    ForEach(projectsViewModel.projects, id: \.id) { project in
                        if project.name == "Daily Tasks" {
                            NewDailyTask(
                                total: project.task_total,
                                completed: project.task_completed,
                                id: project.id,
                                detailRequired: true,
                                createTask: { title, isCompleted, due, projectId in
                                    Task {
                                        await createTask(title: title, isCompleted: isCompleted, due: due, projectId: projectId)
                                    }
                                }
                            )
                            .padding(.bottom, 40)
                        } else {
                            NewProjectTask(
                                title: project.name,
                                total: project.task_total,
                                completed: project.task_completed,
                                id: project.id,
                                detailRequired: true,
                                createTask: { title, isCompleted, due, projectId in
                                    Task {
                                        await createTask(title: title, isCompleted: isCompleted, due: due, projectId: projectId)
                                    }
                                }
                            ).padding(.bottom, 40)
                        }
                    }
                    ButtonBadge(
                        title: "New Project",
                        action: {
                            withAnimation(.spring) {
                                showCreateProject.toggle()
                            }
                        },
                        textColor: .invert,
                        strokeColor: .primary.opacity(0.3),
                        fillColor: .primary.opacity(0.9)
                    )
                }
            }
            .onAppear() {
                Task {
                    await projectsViewModel.fetchProjects(userId: currentUserId ?? 0)
                }
            }
            if showCreateProject {
                CreateProject(show: $showCreateProject)
                    .transition(.move(edge: .bottom))
            }
        }
        .environmentObject(projectsViewModel)
    }
}

extension Home {
    func createTask(title: String, isCompleted: Bool = false, due: Date, projectId: Int) async {
        Task {
            await projectsViewModel.createTask(title: title, due: due, projectId: projectId, userId: currentUserId ?? 0)
        }
    }
}

#Preview {
    Home()
}

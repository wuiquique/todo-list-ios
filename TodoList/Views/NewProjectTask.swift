import SwiftUI

struct NewProjectTask: View {
    let title: String
    let total: Int
    let completed: Int
    let id: Int
    let detailRequired: Bool
    let createTask: (String, Bool, Date, Int) -> Void
    let inTasksView: Bool
    
    init(title: String, total: Int, completed: Int, id: Int, detailRequired: Bool = false, createTask: @escaping (_ title: String, _ isCompleted: Bool, _ due: Date, _ projectId: Int) -> Void, inTasksView: Bool = false) {
        self.title = title
        self.total = total
        self.completed = completed
        self.id = id
        self.detailRequired = detailRequired
        self.createTask = createTask
        self.inTasksView = inTasksView
    }
    
    @State private var showCreate = false
    
    @State private var showActions = false
    
    @State private var showDetail = false
    
    @EnvironmentObject private var projectsViewModel: ProjectViewModel
    @EnvironmentObject private var taskViewModel: TaskViewModel
    
    @AppStorage("userId") var currentUserId: Int?
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .foregroundColor(.white)
                .font(.system(size: 48, weight: .heavy, design: .monospaced))
                .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
            HStack {
                ZStack(alignment: .bottom) {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white, lineWidth: 2)
                        .frame(width: 20, height: 60)
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 20, height: completed == 0 ? 0 : CGFloat(completed)/CGFloat(total) * 60)
                        .foregroundColor(Color.white)
                }
                VStack {
                    Text("\(completed)/\(total)")
                        .foregroundColor(.white)
                        .font(.title)
                        .fontWeight(.bold)
                    Text("tasks")
                        .foregroundColor(.white)
                }
                .padding(.leading, 10)
            }
            Spacer()
            HStack {
                Button(action: {
                    showActions.toggle()
                }) {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 68, height: 68)
                        .background(Color.white.opacity(0.2))
                        .clipShape(Circle())
                        .overlay(
                            Circle().stroke(Color.white, lineWidth: 1)
                        )
                }
                .actionSheet(isPresented: $showActions, content: getActionSheet)
                Spacer()
                Button(action: {
                    showCreate.toggle()
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 24))
                        .foregroundColor(.black.opacity(0.8))
                        .padding()
                        .frame(width: 68, height: 68)
                        .background(Color.white.opacity(0.6))
                        .clipShape(Circle())
                }
                .sheet(isPresented: $showCreate) {
                    CreateTask(currentProject: id, createTask: createTask)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity, minHeight: 320, maxHeight: 320, alignment: .leading)
        .padding(40)
        .background(
            BackgroundProject(isDaily: false)
        )
        .onTapGesture {
            openProject(id: id)
        }
        .sheet(isPresented: $showDetail) {
            ProjectTasksList(
                isDaily: projectsViewModel.projects.first(where: { $0.id == id })?.name == "Daily Tasks" ? true : false,
                id: id
            )
        }
    }
}

extension NewProjectTask {
    func openProject(id: Int) {
        if detailRequired {
            showDetail.toggle()
        }
    }
    
    func getActionSheet() -> ActionSheet {
        let button1: ActionSheet.Button = .destructive(Text("Delete")) {
            presentationMode.wrappedValue.dismiss()
            Task {
                await projectsViewModel.deleteProject(projectId: id, userId: currentUserId ?? 0)
            }
        }
        let button2: ActionSheet.Button = .default(Text("All Done")) {
            Task {
                await projectsViewModel.toggleAll(projectId: id, isCompleted: true, userId: currentUserId ?? 0)
                if inTasksView {
                    await taskViewModel.fetchTasks(projectId: id)
                }
            }
        }
        let button4: ActionSheet.Button = .default(Text("All Incomplete")) {
            Task {
                await projectsViewModel.toggleAll(projectId: id, isCompleted: false, userId: currentUserId ?? 0)
                if inTasksView {
                    await taskViewModel.fetchTasks(projectId: id)
                }
            }
        }
        let button3: ActionSheet.Button = .cancel()
        
        return ActionSheet(title: Text("Project Settings"), buttons: [button4, button2, button1, button3])
    }
}

#Preview {
    NewProjectTask(title: "Test", total: 7, completed: 5, id: 1, createTask: { title,isCompleted,due,projectId in print("Test") })
}

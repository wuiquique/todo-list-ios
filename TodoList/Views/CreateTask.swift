import SwiftUI

struct CreateTask: View {
    @Environment(\.presentationMode) var presentationMode
    
    let currentProject: Int
    let createTask: (String, Bool, Date, Int) -> Void
    
    init(currentProject: Int, createTask: @escaping (_ title: String, _ isCompleted: Bool, _ due: Date, _ projectId: Int) -> Void) {
        self.currentProject = currentProject
        self.createTask = createTask
    }
    
    @State private var selectedProject: Int?
    
    private let today: Date = Calendar.current.startOfDay(for: Date())
    private let tomorrow: Date = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
    
    @State private var date: Date = Calendar.current.startOfDay(for: Date())
    @State private var notification: Bool = false
    @State private var rotationAngle: Double = 0
    @State private var showNewProject: Bool = false
    @State private var projectName: String = ""
    @State private var taskTitle: String = ""
    
    @EnvironmentObject private var projectsViewModel: ProjectViewModel
    
    @AppStorage("userId") var currentUserId: Int?
    
    var body: some View {
        VStack(alignment: .leading) {
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
            Text("New Task")
                .foregroundColor(.primary)
                .font(.system(size: 40, weight: .heavy, design: .monospaced))
                .padding(.leading)
            ChooseDayTask(
                today: today,
                tomorrow: tomorrow,
                date: $date,
                notification: $notification,
                rotationAngle: $rotationAngle
            )
            .padding(.leading)
            ChooseProjectTask(
                showNewProject: $showNewProject,
                currentProject: currentProject,
                selectedProject: $selectedProject
            )
            .padding(.leading)
            if showNewProject {
                TextField("Project name", text: $projectName)
                    .padding()
                    .multilineTextAlignment(.leading)
                    .background(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color.primary.opacity(0.3), lineWidth: 1)
                    )
                    .padding(.top, 4)
                    .padding(.horizontal)
                    .transition(.move(edge: .trailing))
                    .animation(.spring(), value: showNewProject)
            }
            Text("Task".uppercased())
                .kerning(2)
                .padding(.top)
                .font(.headline)
                .foregroundColor(.primary.opacity(0.7))
                .padding(.leading)
            TextField("Task title", text: $taskTitle)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.primary.opacity(0.3), lineWidth: 1)
                )
                .padding(.horizontal)
                .multilineTextAlignment(.leading)
            Spacer()
            ButtonBadge(
                title: "Create",
                action: callCreation,
                textColor: .invert,
                strokeColor: Color.primary.opacity(0.3),
                fillColor: Color.primary.opacity(0.9),
                fullScreen: true
            )
            .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

extension CreateTask {
    func callCreation() {
        if showNewProject {
            presentationMode.wrappedValue.dismiss()
            Task {
                await projectsViewModel.createTaskNewProyect(projectName: projectName, userId: currentUserId ?? 0, taskTitle: taskTitle, due: date)
            }
        } else {
            createTask(taskTitle, false, date, selectedProject ?? currentProject)
            presentationMode.wrappedValue.dismiss()
            Task {
                await projectsViewModel.fetchProjects(userId: currentUserId ?? 0)
            }
        }
    }
}

#Preview {
    CreateTask(
        currentProject: 1, createTask: { title,isCompleted,due,projectId in print("Test") }
    )
}

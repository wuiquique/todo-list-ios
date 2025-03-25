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
    
    @State private var taskError: Bool = false
    @State private var projectError: Bool = false
    
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
                TextFieldComponent(
                    placeholder: "Project name",
                    textVariable: $projectName,
                    showError: projectError,
                    errorMessage: "Project name can't be empty",
                    resetError: { projectError = false }
                )
                .padding(.horizontal)
                .transition(.move(edge: .trailing))
                .animation(.spring, value: showNewProject)
            }
            Text("Task".uppercased())
                .kerning(2)
                .padding(.top)
                .font(.headline)
                .foregroundColor(.primary.opacity(0.7))
                .padding(.leading)
            TextFieldComponent(
                placeholder: "Task title",
                textVariable: $taskTitle,
                showError: taskError,
                errorMessage: "Task title can't be empty",
                resetError: { taskError = false }
            ).padding(.horizontal)
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
            if projectName.isEmpty {
                projectError = true
                return
            }
            presentationMode.wrappedValue.dismiss()
            Task {
                await projectsViewModel.createTaskNewProyect(projectName: projectName, userId: currentUserId ?? 0, taskTitle: taskTitle, due: date)
            }
        } else {
            if taskTitle.isEmpty {
                taskError = true
                return
            }
            presentationMode.wrappedValue.dismiss()
            Task {
                createTask(taskTitle, false, date, selectedProject ?? currentProject)
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

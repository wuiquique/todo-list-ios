import SwiftUI

struct CreateProject: View {
    
    @State private var name: String = ""
    
    @EnvironmentObject private var projectsViewModel: ProjectViewModel
    @AppStorage("userId") var currentUserId: Int?
    
    @Environment(\.presentationMode) var presentationMode
    
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
            
            Spacer()
            
            Text("New Project")
                .foregroundColor(.primary)
                .font(.system(size: 40, weight: .heavy, design: .monospaced))
            TextFieldComponent(placeholder: "House Chores", textVariable: $name, label: "Project Name", topPadding: 0.5)
            ButtonBadge(
                title: "Create Project",
                action: {
                    Task {
                        await projectsViewModel.createProject(name: name, userId: currentUserId ?? 0)
                        withAnimation(.spring) {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                },
                textColor: .invert,
                strokeColor: .primary.opacity(0.3),
                fillColor: .primary.opacity(0.9),
                fullScreen: true
            )
            .padding(.bottom, (projectsViewModel.projects.filter({ $0.name == "Daily Tasks" }).count == 0) ? 0 : 20)
            if (projectsViewModel.projects.filter({ $0.name == "Daily Tasks" }).count == 0) {
                ButtonBadge(
                    title: "Create Daily Tasks",
                    action: {
                        Task {
                            await projectsViewModel.createProject(name: "Daily Tasks", userId: currentUserId ?? 0)
                            withAnimation(.spring) {
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                    },
                    textColor: .primary,
                    strokeColor: .primary.opacity(0.1),
                    fillColor: .primary.opacity(0.2),
                    fullScreen: true
                )
                .padding(.bottom)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    CreateProject()
}

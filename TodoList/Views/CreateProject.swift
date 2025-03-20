import SwiftUI

struct CreateProject: View {
    
    @Binding var show: Bool
    
    @State private var name: String = ""
    
    @EnvironmentObject private var projectsViewModel: ProjectViewModel
    @AppStorage("userId") var currentUserId: Int?
    
    var body: some View {
        VStack {
            Spacer()
            Rectangle()
                .frame(width: .infinity, height: (projectsViewModel.projects.filter({ $0.name == "Daily Tasks" }).count == 0) ? 400 : 350)
                .background(.ultraThinMaterial)
                .cornerRadius(30)
                .overlay {
                    VStack(alignment: .leading) {
                        Button(action: {
                            withAnimation(.spring) {
                                show.toggle()
                            }
                        }, label: {
                            Image(systemName: "xmark")
                                .font(.headline)
                                .foregroundColor(.invert.opacity(0.9))
                                .background(
                                    Circle()
                                        .stroke(Color.invert.opacity(0.3), lineWidth: 1)
                                        .frame(width: 48, height: 48)
                                )
                        })
                        .padding()
                        
                        Spacer()
                                
                        Text("New Project")
                            .foregroundColor(.invert)
                            .font(.system(size: 40, weight: .heavy, design: .monospaced))
                        TextFieldComponent(placeholder: "House Chores", textVariable: $name, label: "Project Name", invertColors: true)
                        ButtonBadge(
                            title: "Create Project",
                            action: {
                                Task {
                                    await projectsViewModel.createProject(name: name, userId: currentUserId ?? 0)
                                    withAnimation(.spring) {
                                        show.toggle()
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
                                            show.toggle()
                                        }
                                    }
                                },
                                textColor: .primary,
                                strokeColor: .invert.opacity(0.3),
                                fillColor: .invert.opacity(0.5),
                                fullScreen: true
                            )
                            .padding(.bottom)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    struct PreviewContainer: View {
        @State var show: Bool = false
        var body: some View {
            CreateProject(show: $show)
        }
    }
    return PreviewContainer()
}

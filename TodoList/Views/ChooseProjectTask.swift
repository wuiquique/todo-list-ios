import SwiftUI

struct ChooseProjectTask: View {
    @Binding var showNewProject: Bool
    let currentProject: Int
    @Binding var selectedProject: Int?
    
    @EnvironmentObject private var projectsViewModel: ProjectViewModel
    
    var body: some View {
        Text("Projects".uppercased())
            .kerning(2)
            .padding(.top)
            .font(.headline)
            .foregroundColor(.primary.opacity(0.7))
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ButtonCreateCancel(
                    action: {
                        withAnimation(.bouncy) {
                            showNewProject.toggle()
                        }
                    },
                    isActive: showNewProject
                )
                ForEach(projectsViewModel.projects, id: \.id) { project in
                    ButtonSelectProject(
                        action: {
                            selectedProject = project.id
                        },
                        title: project.name,
                        id: project.id,
                        currentProject: currentProject,
                        selectedProject: selectedProject,
                        isNewProject: showNewProject
                    )
                }
            }
            .padding(.vertical, 4)
            .padding(.trailing)
        }
    }
}

#Preview {
    struct PreviewContainer: View {
        @State var showNewProject: Bool = false
        @State var selectedProject: Int? = 2
        
        var body: some View {
            ChooseProjectTask(
                showNewProject: $showNewProject,
                currentProject: 1,
                selectedProject: $selectedProject
            )
        }
    }
    return PreviewContainer()
}

import SwiftUI

struct TaskRow: View {
    let title: String
    let isCompleted: Bool
    let id: Int
    let projectId: Int
    
    @EnvironmentObject private var taskViewModel: TaskViewModel
    @EnvironmentObject private var projectsViewModel: ProjectViewModel
    
    @AppStorage("userId") var currentUserId: Int?
    
    var body: some View {
        HStack {
            Button(action: {
                Task {
                    await taskViewModel.toogleTask(id: id, projectId: projectId)
                    await projectsViewModel.fetchProjects(userId: currentUserId ?? 0)
                }
            }) {
                Circle()
                    .stroke(isCompleted ? .clear : .primary.opacity(0.3), lineWidth: 1)
                    .fill(isCompleted ? Color.primary.opacity(0.1) : .clear)
                    .frame(width: 40, height: 40, alignment: .center)
                    .overlay {
                        if isCompleted {
                            Image(systemName: "checkmark")
                                .foregroundColor(.black)
                        }
                    }
            }
            .padding(.trailing, 8)
            Text(title)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(isCompleted ? .primary.opacity(0.3) : .primary)
                .strikethrough(isCompleted)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    TaskRow(title: "Test", isCompleted: true, id: 1, projectId: 1)
}

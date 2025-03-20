import SwiftUI

struct ButtonSelectProject: View {
    let action: () -> Void
    let title: String
    let id: Int
    let currentProject: Int
    let selectedProject: Int?
    let isNewProject: Bool

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
                .padding()
                .padding(.horizontal, 16)
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(strokeColor, lineWidth: 2)
                        .background(backgroundView)
                )
                .clipped(antialiased: true)
                .cornerRadius(30)
        }
    }

    private var strokeColor: Color {
        if isNewProject {
            return .primary.opacity(0.3)
        }
        if let selectedProject = selectedProject {
            return selectedProject == id ? .primary.opacity(0.2) : .primary.opacity(0.3)
        }
        return currentProject == id ? .primary.opacity(0.2) : .primary.opacity(0.3)
    }

    private var backgroundView: some View {
        if isNewProject {
            return AnyView(Color.clear)
        }
        if let selectedProject = selectedProject {
            if selectedProject == id {
                return AnyView(BackgroundProject(isDaily: title == "Daily Tasks").opacity(0.5))
            }
            return AnyView(Color.clear)
        }
        if currentProject == id {
            return AnyView(BackgroundProject(isDaily: title == "Daily Tasks").opacity(0.5))
        }
        return AnyView(Color.clear)
    }
}

#Preview {
    ButtonSelectProject(
        action: { print("Button clicked") },
        title: "Preview",
        id: 1,
        currentProject: 1,
        selectedProject: nil,
        isNewProject: false
    )
}

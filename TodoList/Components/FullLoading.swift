import SwiftUI

struct FullLoading<Content: View>: View {
    let title: String
    let isLoading: Bool
    let content: Content

    init(title: String, isLoading: Bool, @ViewBuilder content: () -> Content) {
        self.title = title
        self.isLoading = isLoading
        self.content = content()
    }

    var body: some View {
        ZStack {
            content
                .blur(radius: isLoading ? 6 : 0)
                .opacity(isLoading ? 0.2 : 1)
            
            if isLoading {
                Color.black.opacity(0.1).ignoresSafeArea()
                ProgressView {
                    Text(title)
                        .padding(.top, 4)
                        .font(.title3)
                }
                .controlSize(.large)
            }
        }
    }
}

#Preview {
    FullLoading(title: "Accessing to your account", isLoading: true) {
        Text("Your content here")
            .font(.title)
    }
}

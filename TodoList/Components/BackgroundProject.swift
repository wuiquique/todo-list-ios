import SwiftUI

struct BackgroundProject: View {
    let isDaily: Bool
    
    var body: some View {
        RoundedRectangle(cornerRadius: 80)
            .fill(Color(isDaily ? "Info" : "Accent2"))
            .overlay(
                Circle()
                    .fill(Color(isDaily ? "Main" : "Accent3"))
                    .frame(width: 300)
                    .overlay(
                        Circle()
                            .fill(Color(isDaily ? "Sub" : "Accent"))
                            .frame(width: 150)
                    )
            )
            .blur(radius: 4)
            .opacity(0.7)

    }
}

#Preview {
    BackgroundProject(isDaily: false)
}

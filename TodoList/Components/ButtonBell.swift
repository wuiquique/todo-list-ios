import SwiftUI

struct ButtonBell: View {
    let action: () -> Void
    let isActive: Bool
    let rotationAngle: Double
    
    var body: some View {
        Button(action: action, label: {
            Image(systemName: isActive ? "bell.badge.fill" : "bell.badge")
                .font(.title3)
                .foregroundColor(isActive ? .invert : .primary.opacity(0.9))
                .background(
                    Circle()
                        .stroke(isActive ? .clear : .primary.opacity(0.3), lineWidth: 2)
                        .fill(isActive ? Color.primary.opacity(0.9) : Color.clear)
                        .frame(width: 48, height: 48)
                )
                .rotationEffect(Angle(degrees: rotationAngle))
        })
            .padding()
    }
}

#Preview {
    ButtonBell(action: { print("Button clicked") }, isActive: true, rotationAngle: 0.0)
}

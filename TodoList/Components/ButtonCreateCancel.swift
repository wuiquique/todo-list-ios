import SwiftUI

struct ButtonCreateCancel: View {
    let action: () -> Void
    let isActive: Bool
    
    var body: some View {
        Button(action: action, label: {
            Image(systemName: "plus")
                .font(.title3)
                .foregroundColor(isActive ? .invert : .primary.opacity(0.9))
                .background(
                    Circle()
                        .stroke(isActive ? Color.clear : Color.primary.opacity(0.3), lineWidth: 2)
                        .fill(isActive ? Color.primary.opacity(0.9) : Color.clear)
                        .frame(width: 48, height: 48)
                )
                .rotationEffect(isActive ? Angle(degrees: 45) : .zero)
        })
            .padding()
    }
}

#Preview {
    ButtonCreateCancel(action: { print("Button clicked") }, isActive: true)
}

import SwiftUI

struct ButtonBadge: View {
    let title: String
    let action: () -> Void
    let textColor: Color
    let strokeColor: Color
    let fillColor: Color
    let fullScreen: Bool
    let isLoading: Bool
    
    init(title: String, action: @escaping () -> Void, textColor: Color, strokeColor: Color, fillColor: Color, fullScreen: Bool = false, isLoading: Bool = false) {
        self.title = title
        self.action = action
        self.textColor = textColor
        self.strokeColor = strokeColor
        self.fillColor = fillColor
        self.fullScreen = fullScreen
        self.isLoading = isLoading
    }
    
    var body: some View {
        Button(action: action) {
            if isLoading {
                ProgressView()
                    .foregroundColor(textColor)
                    .padding()
                    .frame(maxWidth: fullScreen ? .infinity : nil)
                    .padding(.horizontal, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(strokeColor.opacity(0.4), lineWidth: 1)
                            .fill(fillColor.opacity(0.4))
                    )
            } else {
                Text(title)
                    .font(.headline)
                    .foregroundColor(textColor)
                    .padding()
                    .frame(maxWidth: fullScreen ? .infinity : nil)
                    .padding(.horizontal, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(strokeColor, lineWidth: 1)
                            .fill(fillColor)
                    )
            }
        }.disabled(isLoading)
    }
}

#Preview {
    ButtonBadge(
        title: "Today", action: {print("Button clicked")}, textColor: .black, strokeColor: .black, fillColor: .clear
    )
}

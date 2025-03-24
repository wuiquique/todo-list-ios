import SwiftUI

/// Generic TextField align with the app design
///
/// - Parameter placeholder: This is the placeholder that shows when the TextField is empty
/// - Parameter textVariable: @Binding of the @State variable corresponding to the value
/// - Parameter noStartingCapitalization: Declare if the user input must not start with a Capitalized letter
/// - Parameter label: Optional String that represents the top label of the TextField, if not passed, no label is shown
/// - Parameter showError: Optional Bool if error handling is wanted
/// - Parameter errorMessage: Optional String when error is handled and an error message is required
struct TextFieldComponent: View {
    let placeholder: String
    @Binding var textVariable: String
    let noStartingCapitalization: Bool
    let label: String?
    let showError: Bool?
    let errorMessage: String?
    let resetError: () -> Void?
    let topPadding: CGFloat?
    
    @State private var shakeOffset: CGFloat = 0
    @State private var textEditing: Bool = false
    
    init(placeholder: String, textVariable: Binding<String>, noStartingCapitalization: Bool = false, label: String? = nil, showError: Bool = false, errorMessage: String = "", resetError: @escaping () -> Void = { }, topPadding: CGFloat? = nil) {
        self.placeholder = placeholder
        self._textVariable = textVariable
        self.noStartingCapitalization = noStartingCapitalization
        self.label = label
        self.showError = showError
        self.errorMessage = errorMessage
        self.resetError = resetError
        self.topPadding = topPadding
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if let label = label {
                Text(label.uppercased())
                    .kerning(2)
                    .padding(.top, topPadding ?? nil)
                    .font(.caption)
                    .foregroundColor(.primary.opacity(0.7))
                    .padding(.leading)
            }
            TextField(placeholder, text: $textVariable)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(showError ?? false ? Color.red : Color.primary.opacity(0.3), lineWidth: 1)
                        .fill(.clear)
                )
                .multilineTextAlignment(.leading)
                .textInputAutocapitalization(noStartingCapitalization ? .never : nil)
                .offset(x: shakeOffset)
                .onChange(of: showError) { oldValue, newValue in
                    if newValue == true {
                        withAnimation(.spring(duration: 0.2)) {
                            shakeOffset = 10
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            withAnimation(.spring(duration: 0.2)) {
                                shakeOffset = -10
                            }
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                            withAnimation(.spring(duration: 0.2)) {
                                shakeOffset = 0
                            }
                        }
                    }
                }
                .onChange(of: textVariable) { _, _ in
                    resetError()
                }
            if showError ?? false {
                Text(errorMessage ?? "")
                    .font(.caption)
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
    }
}

#Preview {
    struct PreviewContainer: View {
        @State var textVariable: String = ""
        var body: some View {
            TextFieldComponent(placeholder: "Test", textVariable: $textVariable, label: "Dummy")
        }
    }
    return PreviewContainer()
}

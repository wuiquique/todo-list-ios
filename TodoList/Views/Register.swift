import SwiftUI

struct Register: View {
    @State private var name = ""
    @State private var username = ""
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var isLoading: Bool = false
    
    @AppStorage("userId") var currentUserId: Int?
    @AppStorage("name") var currentName: String?
    @AppStorage("username") var currentUsername: String?
    
    var body: some View {
        VStack {
            Text("✅")
                .font(.largeTitle)
            Text("Create an account")
                .font(.title)
                .fontWeight(.heavy)
                .fontDesign(.monospaced)
            Text("Sign up and be part of the community!")
                .font(.subheadline)
                .foregroundColor(.secondary)
            VStack(alignment: .leading) {
                TextFieldComponent(
                    placeholder: "First Last",
                    textVariable: $name,
                    label: "Your name"
                )
                TextFieldComponent(
                    placeholder: "taskmonster",
                    textVariable: $username,
                    noStartingCapitalization: true,
                    label: "Username"
                )
                ButtonBadge(
                    title: "Create Account",
                    action: {
                        Task {
                            await register(name: name, username: username)
                        }
                    },
                    textColor: .invert,
                    strokeColor: Color.primary.opacity(0.3),
                    fillColor: Color.primary.opacity(0.9),
                    fullScreen: true,
                    isLoading: isLoading
                ).padding(.top)
            }.padding(.horizontal, 40)
            HStack {
                Text("Already have an account?")
                    .foregroundColor(.secondary)
                Button {
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Log in here")
                }
            }
            .font(.subheadline)
            .padding(.top)
        }
    }
}

extension Register {
    func register(name: String, username: String) async {
        isLoading = true
        let postBody = ["name": name, "username": username]
        let url = "http://localhost:8000/register"
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: postBody)
            
            let newPost: UserModel = try await NetworkUtils.fetchData(from: url, method: .POST, body: jsonData)
            
            currentUserId = newPost.id
            currentName = newPost.name
            currentUsername = newPost.username
            isLoading = false
        } catch {
            print("Error al hacer Login: \(error)")
            isLoading = false
        }
    }
}

#Preview {
    Register()
}

import SwiftUI

struct Login: View {
    
    @State private var username: String = ""
    @State private var isLoading: Bool = false
    @State private var userNameError: Bool = false
    
    @AppStorage("userId") var currentUserId: Int?
    @AppStorage("name") var currentName: String?
    @AppStorage("username") var currentUsername: String?
    
    var body: some View {
        VStack {
            Text("✅")
                .font(.largeTitle)
            Text("Welcome back")
                .font(.title)
                .fontWeight(.heavy)
                .fontDesign(.monospaced)
            Text("Glad to see you again! 👋")
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text("Login to your account below")
                .font(.subheadline)
                .foregroundColor(.secondary)
            VStack(alignment: .leading) {
                TextFieldComponent(
                    placeholder: "taskmonster",
                    textVariable: $username,
                    noStartingCapitalization: true,
                    label: "Username",
                    showError: userNameError,
                    errorMessage: "Username not found",
                    resetError: resetErrors
                )
                ButtonBadge(
                    title: "Login",
                    action: {
                        Task {
                            await login(username)
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
                Text("Don't have an account?")
                    .foregroundColor(.secondary)
                NavigationLink {
                    Register()
                } label: {
                    Text("Sign up for Free")
                }
                
            }
            .font(.subheadline)
            .padding(.top)
        }
    }
}

extension Login {
    func login(_ username: String) async {
        isLoading = true
        let postBody = ["username": username]
        let url = "http://localhost:8000/login"
        
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
            userNameError = true
        }
    }
    
    func resetErrors () {
        userNameError = false
    }
}

#Preview {
    Login()
}

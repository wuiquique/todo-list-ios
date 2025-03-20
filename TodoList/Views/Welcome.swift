import SwiftUI

struct Welcome: View {
    let userName: String
    let projectsCount: Int
    
    @State private var showUserActions: Bool = false
    
    @AppStorage("userId") var currentUserId: Int?
    @AppStorage("name") var currentName: String?
    @AppStorage("username") var currentUsername: String?
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Hello, \(userName)!")
                .font(.title3)
                .fontWeight(.light)
            HStack {
                VStack(alignment: .leading) {
                    Text("Your")
                        .font(.system(size: 40, weight: .heavy, design: .monospaced))
                    HStack {
                        Text("Projects")
                            .font(.system(size: 40, weight: .heavy, design: .monospaced))
                        Text("(\(projectsCount))")
                            .font(.largeTitle)
                        Spacer()
                    }
                }
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .foregroundColor(.primary.opacity(0.9))
                    .frame(width: 60, height: 60)
                    .onTapGesture {
                        showUserActions.toggle()
                    }
                    .actionSheet(isPresented: $showUserActions, content: getActionSheet)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
}

extension Welcome {
    func getActionSheet() -> ActionSheet {
        let button1: ActionSheet.Button = .destructive(Text("Log out")) {
            currentUserId = nil
            currentName = nil
            currentUsername = nil
        }
        let button3: ActionSheet.Button = .cancel()
        
        return ActionSheet(title: Text("User Settings"), buttons: [button1, button3])
    }
}

#Preview {
    Welcome(userName: "Luis", projectsCount: 6)
}

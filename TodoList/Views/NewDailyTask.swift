import SwiftUI

struct NewDailyTask: View {
    let total: Int
    let completed: Int
    let id: Int
    let detailRequired: Bool
    let createTask: (String, Bool, Date, Int) -> Void
    
    init(total: Int, completed: Int, id: Int, detailRequired: Bool = false, createTask: @escaping (_ title: String, _ isCompleted: Bool, _ due: Date, _ projectId: Int) -> Void) {
        self.total = total
        self.completed = completed
        self.id = id
        self.detailRequired = detailRequired
        self.createTask = createTask
    }
    
    @State private var showCreate = false
    
    @State private var showDetail = false
    
    @EnvironmentObject private var projectsViewModel: ProjectViewModel

    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Daily Tasks")
                .foregroundColor(.white)
                .font(.system(size: 48, weight: .heavy, design: .monospaced))
                .frame(width: 150)
            Spacer()
            HStack {
                ZStack(alignment: .bottom) {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white, lineWidth: 2)
                        .frame(width: 20, height: 60)
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 20, height: completed == 0 ? 0 : CGFloat(completed)/CGFloat(total) * 60)
                        .foregroundColor(Color.white)
                }
                VStack {
                    Text("\(completed)/\(total)")
                        .foregroundColor(.white)
                        .font(.title)
                        .fontWeight(.bold)
                    Text("tasks")
                        .foregroundColor(.white)
                }
                .padding(.leading, 10)
            }
            Spacer()
            VStack {
                Button(action: {
                    showCreate.toggle()
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 24))
                        .foregroundColor(.black.opacity(0.8))
                        .padding()
                        .frame(width: 68, height: 68)
                        .background(Color.white.opacity(0.6))
                        .clipShape(Circle())
                }
                .sheet(isPresented: $showCreate) {
                    CreateTask(currentProject: id, createTask: createTask)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity, minHeight: 320, maxHeight: 320, alignment: .leading)
        .padding(40)
        .background(
            BackgroundProject(isDaily: true)
        )
        .onTapGesture {
            openProject(id: id)
        }
        .sheet(isPresented: $showDetail) {
            ProjectTasksList(
                isDaily: projectsViewModel.projects.first(where: { $0.id == id })?.name == "Daily Tasks" ? true : false,
                id: id
            )
        }
    }
}

extension NewDailyTask {
    func openProject(id: Int) {
        if detailRequired {
            showDetail.toggle()
        }
    }
}

#Preview {
    NewDailyTask(
        total: 8,
        completed: 3,
        id: 1,
        createTask: { title,isCompleted,due,projectId in print("Test") }
    )
}

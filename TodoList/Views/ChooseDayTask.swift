import SwiftUI

struct ChooseDayTask: View {
    let today: Date
    let tomorrow: Date
    @Binding var date: Date
    @Binding var notification: Bool
    @Binding var rotationAngle: Double
    
    var body: some View {
        HStack {
            ButtonBadge(
                title: "Today",
                action: {
                    date = today
                },
                textColor: date == today ? .invert : .primary,
                strokeColor: date != today ? .primary.opacity(0.3) : .clear,
                fillColor: date == today ? .primary.opacity(0.9) : .clear
            )
            ButtonBadge(
                title: "Tomorrow",
                action: {
                    date = tomorrow
                },
                textColor: date == tomorrow ? .invert : .primary,
                strokeColor: date != tomorrow ? .primary.opacity(0.3) : .clear,
                fillColor: date == tomorrow ? .primary.opacity(0.9) : .clear
            )
        }
        ButtonBell(
            action: {
                withAnimation(.spring(duration: 0.2)) {
                    notification.toggle()
                    rotationAngle = notification ? -15 : 0
                }
                
                if notification {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        withAnimation(.spring(duration: 0.2)) {
                            rotationAngle = 15
                        }
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        withAnimation(.spring(duration: 0.2)) {
                            rotationAngle = 0
                        }
                    }
                }
            },
            isActive: notification,
            rotationAngle: rotationAngle
        )
    }
}

#Preview {
    struct PreviewContainer: View {
        @State var rotationAngle: Double = 0
        @State var notification: Bool = false
        @State var date: Date = Calendar.current.startOfDay(for: Date())
        
        var body: some View {
            ChooseDayTask(
                today: Calendar.current.startOfDay(for: Date()),
                tomorrow: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
                date: $date,
                notification: $notification,
                rotationAngle: $rotationAngle)
        }
    }
    return PreviewContainer()
}

import SwiftUI

struct LongTapCard: View {
    @EnvironmentObject var dm: DM
    
    let card: CardModel
    
    @State var isShowMinusIcon = false
    @State var isShaking = false
    @State var isShowAlert = false
    @State var alertMessage = ""
    
    var body: some View {
        ZStack {
            CardView(card: card, hasChildren: true)
                .offset(x: isShaking ? -1 : 1.5, y: isShaking ? -1 : 1)
                .animation(Animation.easeOut(duration: 0.1).repeatCount(50, autoreverses: true), value: isShaking)
                .onLongPressGesture {
                    isShaking.toggle()
                    isShowMinusIcon.toggle()
                }
            
            if isShaking {
                Button {
                    alertMessage = "Are you sure you want to remove this item?!"
                    isShowAlert = true
                } label: {
                    Image(systemName: "minus.circle.fill")
                        .font(.system(size: 30))
                        .foregroundStyle(Color(hex: "71BBB2"))
                }
                .offset(x: -50, y: -50)
            }
        }
        .alert(isPresented: $isShowAlert) {
            Alert(
                title: Text("Please confirm"),
                message: Text(alertMessage),
                primaryButton: .destructive(Text("Delete")),
                secondaryButton: .default(Text("Cancel"))
            )
        }
    }
}

#Preview {
    let card = CardModel(cardId: 1, titleKey: "Animals", groupId: 1, imageName: "puzzle", priority: 1)
    let dm = DM() // Создайте экземпляр DM
    LongTapCard(card: card)
        .environmentObject(dm) // Передайте его в окружение
}




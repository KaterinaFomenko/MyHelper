//
//  LongTapCard2.swift
//  Helper
//
//  Created by Катерина Фоменко on 22/03/2025.
//

import SwiftUI

struct LongTapCard2: View {
    
   // @EnvironmentObject var dm: DM
    let card: CardModel
    @Binding var isShowAlert: Bool
    @Binding var message: String
    
    var body: some View {
        Menu {
            
            Button("Cancel", systemImage: "house.circle") {
                
            }
            
            Button("Delete item", systemImage: "minus.circle", role: .destructive) {
                isShowAlert = true
            }
        } label: {
            CardView(card: card, hasChildren: true)
        }
        
        .alert(isPresented: $isShowAlert) {
            Alert(title: Text("Are you sure you want to remove this item?"),
                  message: Text(message),
                  primaryButton: .destructive(Text("Delete") ),
                  secondaryButton: .cancel())
        }
    }
}

#Preview {
   // let dm = DM()
    let card = CardModel(cardId: 1, title: "Play", groupId: 1, imageName: "puzzle")
    LongTapCard2(card: card, isShowAlert: .constant(true), message: .constant(""))
     //   .environmentObject(dm)
}

//
//  MainCardGridView.swift
//  Helper
//
//  Created by Катерина Фоменко on 13/02/2025.
//

import SwiftUI

struct MainCardsView: View {
    
    @EnvironmentObject var dm: DM
    var colums = [GridItem(.adaptive(minimum: 100), spacing: 0)]
    
    var body: some View {
        
        LazyVGrid(columns: colums, spacing: 10) {
            
            ForEach(dm.mainArray, id: \.cardId) { card in
                CardView(card: card)
                    .onTapGesture {
                        print("☎️ \(card.title)")

                        if card.childCards?.isEmpty ?? true && card.cardId < 100 {
                           
                            dm.addItemToSelected(item: card)
                        } else {
                            // показываем дочерний элемент
                            if card.cardId == 100 {
                                 dm.mainArray = dm.parentCardsArray
                            } else if card.cardId == 101 {
                                dm.mainArray = dm.parentCardsArray
                            } else {
                                
                                dm.mainArray = card.childCards ?? []
                                var cardHome = CardModel(cardId: 100, title: "Home", groupId: 11, imageName: "home")
                                var cardBack = CardModel(cardId: 101, title: "Back", groupId: 1, imageName: "back1")
                                dm.mainArray.insert(cardHome, at: 0)
                                dm.mainArray.append(cardBack)
                            }
                        }
                    }
            }
        }
        .padding()
    }
}

//#Preview {
//    
//    @Previewable @State var colums = [GridItem(.adaptive(minimum: 100), spacing: 0)]
//    MainCardsView(colums: $colums, isHaveChildCards: <#Binding<Bool>#>)
//        .environmentObject(DM.shared) // передаём $ для Binding
//}

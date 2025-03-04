//
//  MainCardGridView.swift
//  Helper
//
//  Created by Катерина Фоменко on 13/02/2025.
//

import SwiftUI

struct MainCardsView: View {
    @State var isShowAddScreen: Bool = false
    @EnvironmentObject var dm: DM
    
    var colums = [GridItem(.adaptive(minimum: 100), spacing: 0)]
    
    var body: some View {
        
        LazyVGrid(columns: colums, spacing: 10) {
            
            ForEach(dm.mainArray, id: \.cardId) { card in
                CardView(card: card)
                
                    .onTapGesture {
                        dm.speakText(text: card.title)
                        print("☎️ \(card.title)")
                        
                        if card.childCards?.isEmpty ?? true && card.cardId < 100 {
                            // Add new card on top array
                            dm.addItemToSelected(item: card)
                            
                        } else {
                            // tap Home / Back
                            if card.cardId == 100 {
                                dm.titleWay = ""
                                dm.mainArray = dm.parentCardsArray
                                
                            } else if card.cardId == 101 {
                                dm.titleWay = ""
                                dm.mainArray = dm.parentCardsArray
                                
                            } else if card.id == 102 {
                                print("Tap new card ")
                                isShowAddScreen.toggle()
                                
                            } else {
                                // Add path on SettigsView
                                dm.titleWay =  dm.titleWay + " \u{203A} " + card.title
                                
                                // проваливаемся в childCards
                                dm.mainArray = card.childCards ?? []
                                
                                dm.addItemToSelected(item: card)
                                
                                // Add servise buttons
                                let cardHome = CardModel(cardId: 100, title: "Home", groupId: 100, imageName: "home4" )
                                let cardBack = CardModel(cardId: 101, title: "Back", groupId: 101, imageName: "back1")
                                let cardPlus = CardModel(cardId: 102, title: "Plus", groupId: 102, imageName: "plus" )
                                
                                dm.mainArray.insert(cardHome, at: 0)
                                dm.mainArray.append(cardBack)
                                dm.mainArray.append(cardPlus)
                            }
                        }
                    }
            }
        }
        .padding()
        .sheet(isPresented: $isShowAddScreen) {
            NewCardView()
        }
    }
    
    
    
}





//#Preview {
//
//    @Previewable @State var colums = [GridItem(.adaptive(minimum: 100), spacing: 0)]
//    MainCardsView(colums: $colums, isHaveChildCards: <#Binding<Bool>#>)
//        .environmentObject(DM.shared) // передаём $ для Binding
//}




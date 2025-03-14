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
  //  let cardPlus = CardModel(cardId: 102, title: "Plus", groupId: 102, imageName: "plus" )
    
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
                            // tap Home / Back / Plus
                            if card.cardId == 100 { //"home"
                                dm.titleWay = ""
                                dm.mainArray = dm.parentCardsArray
                                dm.childCardIdOpened = -1
                                
                            } else if card.cardId == 101 { //"back"
                                dm.titleWay = ""
                             //   dm.parentCardsArray.append(cardPlus) // ?? почему стало заходить на 89 строку
                                dm.mainArray = dm.parentCardsArray
                                dm.childCardIdOpened = -1
                                
                            } else if card.id == 102 { // "plus"
                                print("Tap new card ")
                            
                                dm.isShowAddScreen.toggle()
                                
                            } else { // проваливаемся в childCards
                                
                                dm.childCardIdOpened = card.cardId
                                // Add path on SettigsView
                                dm.titleWay =  dm.titleWay + " \u{203A} " + card.title
                                
                               
                                dm.mainArray = card.childCards ?? []
                                
                                dm.addItemToSelected(item: card)
                                
                                // Add servise buttons
                                let cardHome = CardModel(cardId: 100, title: "Home", groupId: 100, imageName: "home4" )
                                let cardBack = CardModel(cardId: 101, title: "Back", groupId: 101, imageName: "back1")
                                //let cardPlus = CardModel(cardId: 102, title: "Plus", groupId: 102, imageName: "plus" )
                                
                                dm.mainArray.insert(cardHome, at: 0)
                                dm.mainArray.append(cardBack)
                               // dm.mainArray.append(cardPlus)
                                dm.addPlusCard()
                            }
                        }
                    }
                
            }
        }
        .padding()
        .sheet(isPresented: $dm.isShowAddScreen) {
            NewCardView()
        }
        
        //triggers when pressed BTN Save
        .onChange(of: dm.parentCardsArray) { oldValue, newValue in
            print("On change")
            if dm.childCardIdOpened > 0 {
                // update child screen
                dm.childCardsArray = newValue
                dm.mainArray = dm.childCardsArray
                dm.addPlusCard()
              //  dm.isShowAddScreen = false // close current screen
                
            } else {
                //update main screen
                dm.mainArray = newValue
                dm.addPlusCard()
              //  dm.isShowAddScreen = false
            }
        }
        
        
        
        
    }
    
    

    
}





//#Preview {
//
//    @Previewable @State var colums = [GridItem(.adaptive(minimum: 100), spacing: 0)]
//    MainCardsView(colums: $colums, isHaveChildCards: <#Binding<Bool>#>)
//        .environmentObject(DM.shared) // передаём $ для Binding
//}




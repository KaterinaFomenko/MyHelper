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
                        dm.speakText(text: card.title)
                        print("☎️ \(card.title)")
                        
                        if card.childCards == nil && card.cardId < 100 {
                            // Add new card on top array
                            dm.addItemToSelected(item: card)
                           
                        } else {
                            // tap Home / Back / Plus
                            if card.cardId == 100 { //"home"
                                dm.titleWay = ""
                                dm.mainArray = dm.parentCardsArray
                                dm.addPlusCard()
                                dm.childCardIdOpened = -1
                                
                            } else if card.cardId == 101 { //"back"
                                dm.titleWay = ""
                                dm.mainArray = dm.parentCardsArray
                                dm.addPlusCard()
                                dm.childCardIdOpened = -1
                                
                            } else if card.id == 102 { // "plus"
                                print("Tap new card ")
                            
                                dm.isShowAddScreen.toggle()
                                
                            } else {
                                // проваливаемся в childCards
                                dm.childCardIdOpened = card.cardId
                                // Add path on SettigsView
                                dm.titleWay =  dm.titleWay + " \u{203A} " + card.title
                                
                                dm.mainArray = card.childCards ?? []
                                dm.addItemToSelected(item: card)
                                
                                // Add servise buttons
                                
                                dm.addHomeBackCards()
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
        .onChange(of: dm.parentCardsArray) { oldParentArray, newParentArray in
            return
        }
        
    }
    
    
}

#Preview {
    MainCardsView()
        .environmentObject(DM.shared) 
}


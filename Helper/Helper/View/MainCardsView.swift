//
//  MainCardGridView.swift
//  Helper
//
//  Created by Катерина Фоменко on 13/02/2025.
//

import SwiftUI

struct MainCardsView: View {
    
    @EnvironmentObject var dm: DM
    
    
    @State var isShowAlert = false
    @State var message = ""
    
    var idCurrentCard: Float = 0
    
    var colums = [GridItem(.adaptive(minimum: 100), spacing: 0)]
    
    var body: some View {
        LazyVGrid(columns: colums, spacing: 10) {
            
            ForEach(dm.mainArray, id: \.cardId) { card in
                CardView(card: card, hasChildren: card.childCards != nil)
                
                    .onTapGesture {
                        
                        dm.speakText(text: card.title)
                        print("☎️ card.title: \(card.title), cardId: \(card.cardId)")
                        
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
                                
                                dm.isShowCreateCardScreen.toggle()
                                
                            } else {
                                // проваливаемся в childCards
                                dm.childCardIdOpened = card.cardId
                                // Add path on SettigsView
                                dm.titleWay =  dm.titleWay + " \u{203A} " + card.title
                                
                                dm.mainArray = card.childCards ?? []
                                
                               // let arrayIDs = dm.mainArray.compactMap { "\($0.cardId) : \($0.title)" }
                              //  print("👼 There are all child cards: \( arrayIDs )")
                                
                                dm.addItemToSelected(item: card)
                                
                                // Add servise buttons
                                
                                dm.addHomeBackCards()
                                dm.addPlusCard()
                            }
                        }
                    }

                // MARK: LongPressGesture
                
                    .contextMenu {
                        
                        if card.cardId < 100 && card.priority != 1 {
                            
                            Button(action: {  // Действие при редактировании
                               
                                dm.selectedCardId = card.cardId
                                print("🆔 Show Card for Editing : \(dm.selectedCardId)")
                                
                                // Show new Card
                                dm.isStateEdiding = true
                                dm.isShowCreateCardScreen.toggle()
                                
                            }) {
                                HStack {
                                    Image(systemName: "pencil")
                            
                                    Text("Edit")
                                }
                            }
            
                            Button(action: { // Действие при удалении
                                dm.selectedCardId = card.cardId
                                isShowAlert = true
                            }) {
                                HStack {
                                    Image(systemName: "trash")
                                    Text("Delete")
                                }
                            }
                            
                        }
                    }
            }
        }
        .padding()
        .sheet(isPresented: $dm.isShowCreateCardScreen) {
            NewCardView()
        }
        .alert(isPresented: $isShowAlert) {
           
            // Alert.Button
            Alert(title: Text("Are you sure you want to remove this item?"),
                  message: Text(message),
                  primaryButton: .destructive(Text("Delete"), action: {
                print("Delete item")
                
                dm.removeCardFromId(dm.selectedCardId)
            } ),
                  secondaryButton: .cancel() )
        }
        .animation(.easeInOut, value: isShowAlert)
        
        //triggers when pressed BTN Save
        .onChange(of: dm.parentCardsArray) { oldParentArray, newParentArray in
            print("onChange parentCardsArray")
            return
        }
 .onAppear {
     let arrayIDs = dm.mainArray.map { "\($0.cardId) : \($0.title) : \($0.imageName)" }.joined(separator: "\n")
    
            print("🤵 It`s all parent cards: \(arrayIDs)")
        
        }
    }
}
    
#Preview {
    MainCardsView()
        .environmentObject(DM.shared)
}


//
//  MainCardGridView.swift
//  Helper
//
//  Created by Катерина Фоменко on 13/02/2025.
//

import SwiftUI
import TipKit

struct MainCardsView: View {
    
    @EnvironmentObject var dm: DM
    @EnvironmentObject var settings: Settings
    @EnvironmentObject var coordinator: NavigationCoordinator
    
    @State var isShowAlert = false
    @State var message = ""

   // @Binding  var path: NavigationPath

    var colums = [GridItem(.adaptive(minimum: 100), spacing: 30)]
 //   let colums = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {

            ScrollView {
                LazyVGrid(columns: colums, spacing: 10) {
                    
                    ForEach(dm.mainArray, id: \.cardId) { card in
                            cardView(card: card)
                        
                    }
                }
                .padding()
            }
            
            .alert(isPresented: $isShowAlert) {
                Alert(title: Text("Are you sure you want to remove this item?"),
                      message: Text(message),
                      primaryButton: .destructive(Text("Delete"), action: {
                    dm.removeCardFromId(dm.contextCardId)
                }),
                      secondaryButton: .cancel()
                )
            }
            .animation(.easeInOut, value: isShowAlert)
            
            .onAppear {
                let arrayIDs = dm.mainArray.map { "\($0.cardId) : \($0.titleKey) : \($0.imageName)" }.joined(separator: "\n")
                
                print("🤵 It`s all parent cards: \(arrayIDs)")
                
            }
   //     }
    }
    
    @ViewBuilder
    private func cardView(card: CardModel) -> some View {
        CardView(card: card, hasChildren: card.childCards != nil)
            .onTapGesture {
                handleCardTap(card)
            }
            .contextMenu {
               
                if card.cardId < 100 && card.priority != 1 {
                    Button(action: {
                        editCard(card)
                    }) {
                        HStack {
                            Image(systemName: "pencil")
                            Text("Edit")
                        }
                    }
                   
                    Button(action: {
                        deleteCard(card)
                    }) {
                        HStack {
                            Image(systemName: "trash")
                            Text("Delete")
                        }
                    }
                }
            }
    }
    
    private func handleCardTap(_ card: CardModel) {
        dm.speakText(
            forKey: card.titleKey,
            language: settings.speechLanguage,
            isVoice: settings.voiceGuidance
        )
        print("☎️ card.titleKey: \(card.titleKey), cardId: \(card.cardId)")
        
        if card.childCards == nil && card.cardId < 100 {
            // Add new card on top array
            dm.addItemToSelected(item: card)
            
        } else {
            // tap Home / Back / Plus
            handleSpesialCardTap(card)
            
        }
    }
    
    private func handleSpesialCardTap(_ card: CardModel) {
        
        switch card.cardId {
        case 100:
            resetToHome()
        case 101:
            resetToHome()
        case 102 :
           // dm.isShowCreateCardScreen.toggle()
            openNewCardView(card)
            
        default:
            navigateToChildCard(card)
        }
    }
    
    private func openNewCardView(_ card: CardModel) {
        coordinator.path.append(card)
    }
    
    private func resetToHome() {
        dm.titleWay = ""
        dm.mainArray = dm.parentCardsArray
        dm.addPlusCard()
        dm.parentCardIdOpened = -1
    }
    
    private func navigateToChildCard(_ card: CardModel) {
        // проваливаемся в childCards
        dm.parentCardIdOpened = card.cardId
        // Add path on SettigsView
        dm.titleWay = card.titleKey
        
        dm.mainArray = card.childCards ?? []
        
        // let arrayIDs = dm.mainArray.compactMap { "\($0.cardId) : \($0.titleKey)" }
        //  print("👼 There are all child cards: \( arrayIDs )")
        
        dm.addItemToSelected(item: card)
        dm.addHomeBackCards()
        dm.addPlusCard()
    }
    
    private func deleteCard(_ card: CardModel) {
        dm.contextCardId = card.cardId
        isShowAlert = true
    }
    
    private func editCard(_ card: CardModel) {
        
        
        dm.contextCardId = card.cardId
        print("🆔 Show Card for Editing : \(dm.contextCardId)")
       
        // Show Card увшештп
        dm.isStateEdiding = true
        coordinator.path.append(card)

        //dm.isShowCreateCardScreen.toggle()
    }
    
}

//#Preview {
//    
//    MainCardsView(path: $path)
//        .environmentObject(DM(speechManager: SpeechManager(lang: Settings().storedLanguage)))
//}


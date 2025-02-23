//
//  MainCardGridView.swift
//  Helper
//
//  Created by Катерина Фоменко on 13/02/2025.
//

import SwiftUI
// Вертикальный Grid
struct MainCardsView: View {
    
    @Binding var colums: [GridItem]
    @EnvironmentObject var dm: DM
    
    var body: some View {
        
        LazyVGrid(columns: colums, spacing: 10) {
            //
            ForEach(dm.getConvertedCards(), id: \.cardId) { card in
                CardView(card: card)
                    .onTapGesture {
                        // если childCards
                        if card.childCards?.isEmpty ?? false {
                            dm.addItemToSelected(item: card)
                        } else {
                            // показываем дочерний элемент
                            dm.$mainCardsArray
                        }
                        
                    }
            }
        }
        .padding()
    }
}
        
        
        
        
            
//            ForEach(dm.mainCardsArray) { card in
//                CardView(card: card)
//                    .onTapGesture {
//                        let newCard = CardModel(
//                            id: card.cardId,
//                            title: card.title,
//                            imageName: card.imageName,
//                            color: card.color,
//                            parentId: card.parentId)
//                    }
//                
//            }
//        }
 //   }
        
 //       LazyVGrid(columns: colums, pinnedViews: .sectionHeaders) {
//            Section {
//                ForEach(DM.shared.getCards(section: 0)) { item in
//                    CardView(card: item)
//                        .onTapGesture {
//                            DM.shared.addItemToSelected(item: item)
//                            
//                        }
//                }
//            }
            
//            List {
//                ForEach(DM.shared.cards) { card in
//                    CardModel(id: card.cardId, title: card.title, imageName: card.imageName, color: card.color, parentId: card.parentId)
                    
                    // .onTapGesture {
                    //  DM.shared.addItemToSelected(item: item)
                    
                    //  print("!!!selectedItemsArray: \(DM.shared.selectedItemsArray)")
                    // }
//                }
 //           }
                
//            } header: {
//                Text("General actions")
//                    .font(.largeTitle.bold())
//                    .padding(.bottom, 5)
//            }
//        }
//    }
//}

#Preview {
    
    @Previewable @State var colums = [GridItem(.adaptive(minimum: 100), spacing: 0)]
    return MainCardsView(colums: $colums)
        .environmentObject(DM.shared) // передаём $ для Binding
}

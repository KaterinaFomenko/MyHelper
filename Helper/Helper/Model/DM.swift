//
//  DM.swift
//  Helper
//
//  Created by Катерина Фоменко on 15/02/2025.
//

import Foundation
import SwiftUI

class DM: ObservableObject {
  
    @Published var selectedItemsArray: [CardModel] = [] // for top grid
    @Published var mainCardsArray: [CardModel] = [] //data from Json
    @Published var array: [CardModel] = []

    static let shared = DM()
    
    init() {
        getCardsLoad()
        //initArray()
    }
    /*
    private func initArray() {
        for section in 0..<2 { // section
            var cardArray: [CardModel] = []
            for _ in 0..<15 {
                
                var card = CardModel(from: <#any Decoder#>)
                card.title = "Sleep " + String(section)
                card.imageName = "cubesV_xBG"
                //card. = "green"
                card.groupId = 1
                cardArray.append(card)
                 
            }
            array.append(cardArray)
        }
    }
     */
    
     func addItemToSelected(item: CardModel) {
         if !selectedItemsArray.contains(where: {$0.cardId == item.cardId}) {
            selectedItemsArray.append(item)
            print("Add new item in SelectedArray")
        }
    }
    
    func removeLastItem() {
        if !selectedItemsArray.isEmpty {
            selectedItemsArray.removeLast()
        }
    }
    
    private func getCardsLoad() -> [CardModel] {
        mainCardsArray = load()
        print("🎞️ Загруженные карточки: \(mainCardsArray)")
        return mainCardsArray
    }
    
    func getConvertedCards() -> [CardModel] {
        return mainCardsArray
//        return mainCardsArray.map { cardData in
//            CardModel(
//                cardId: cardData.cardId,
//                title: cardData.title,
//                //colorCard: cardData.color,
//                groupId: cardData.groupId,
//                imageName: cardData.imageName
//                
//            )
//        }
    }
    
    
  
}




//    func getCards(section: Int) -> [CardModel] {
//        guard section < array.count else { return [] }
//         return array[section]
//    }

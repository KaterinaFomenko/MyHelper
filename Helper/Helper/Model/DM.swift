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
    
    @Published var parentCardsArray: [CardModel] = [] // source for perentElements from Json
    @Published var childCardsArray: [CardModel] = []  // source for childElements from Json
    
    @Published var mainArray: [CardModel] = [] // monitor
    static let shared = DM()
    
    init() {
        loadParentCards()
        mainArray = parentCardsArray
    }
    
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
    
    private func loadParentCards() {
        parentCardsArray = load()
        print("🎞️ Загруженные карточки: \(parentCardsArray)")
    }
    
    public func getColor(groupId: Int) -> String {
            switch groupId {
            case 1 :
                return "FCC737"
            case 2 :
                return "F26B0F"
            case 3 :
                return "E73879"
            default:
                return "7E1891"
        }
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
            mainArray.append(cardArray)
        }
    }
     */
    
    
//    func getConvertedCards() -> [CardModel] {
//        let getConvertedCards = parentCardsArray
//       // print("🎞️getConvertedCards : \(getConvertedCards)")
//        return parentCardsArray

//        return parentCardsArray.map { cardData in
//            CardModel(
//                cardId: cardData.cardId,
//                title: cardData.title,
//                //colorCard: cardData.color,
//                groupId: cardData.groupId,
//                imageName: cardData.imageName
//                
//            )
//        }
//    }
    
    
  
}




//    func getCards(section: Int) -> [CardModel] {
//        guard section < mainArray.count else { return [] }
//         return mainArray[section]
//    }

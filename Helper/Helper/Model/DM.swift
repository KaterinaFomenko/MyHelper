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
    
    @Published var titleWay: String = ""
    
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
        case 1:
            return "F4D03F" // Приглушенный желтый
        case 2:
            return "E67E22" // Приглушенный оранжевый
        case 3:
            return "D2527F" // Приглушенный розовый
        case 4:
            return "FF9D23" // Яркий оранжевый
        case 5:
            return "71BBB2" // Яркий оливка
        case 6:
            return "D17D98" // Приглушенный фиолетовый
        case 7:
            return "E74C3C" // Приглушенный красный
        case 8:
            return "E73879" // Яркий розовый
        case 9:
            return "2980B9" // Приглушенный синий
        case 10:
            return "B1C29E" // Оливковый
        case 11:
            return "F39C12" // Приглушенный оранжевый
        case 12:
            return "D35400" // Теплый оранжевый
        case 13:
            return "27AE60" // Приглушенный зеленый
        case 14:
            return "5DADE2" // Приглушенный голубой
        default:
            return "EAEAEA" // Серый (по умолчанию)
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

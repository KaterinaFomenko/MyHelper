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
    @Published var array: [[CardModel]] = []

    static let shared = DM()
    
    init() {
        initArray()
    }
    
    private func initArray() {
        for section in 0..<2 { // section
            var cardArray: [CardModel] = []
            for _ in 0..<15 {
                
                var card = CardModel()
                card.title = "Sleep " + String(section)
                card.image = "cubesV_xBG"
                card.colorSection = .green
                card.groupId = 1
                cardArray.append(card)
            }
            array.append(cardArray)
        }
    }
    
     func addItemToSelected(item: CardModel) {
        if !selectedItemsArray.contains(where: {$0.id == item.id}) {
            selectedItemsArray.append(item)
            print("Add new item in SelectedArray")
        }
    }
    
    func getCards(section: Int) -> [CardModel] {
        guard section < array.count else { return [] }
         return array[section]
    }
    
    /*
    static var rightCards: [CardModel] {
        var array: [CardModel] = []
        
        for _ in 0..<10 {
            let card = CardModel.init(title: "Sleep", image: "cubesV_xBG")
            array.append(card)
        }
        return array
    }
     */
}

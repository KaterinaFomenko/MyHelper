//
//  DM.swift
//  Helper
//
//  Created by Катерина Фоменко on 15/02/2025.
//

import Foundation
import SwiftUI

struct DM {
   
    static var array: [[CardModel]] = [[]]
    static var selectedItemsArray: [CardModel] = [] // for top grid
    
    static func initArray() {
        
        for section in 0..<2 { // section
            var cardArray: [CardModel] = []
            for _ in 0..<25 {
                
                var card = CardModel()
                card.title = "Sleep " + String(section)
                card.image = "cubesV_xBG"
                card.colorSection = .green
                card.groupId = 1
                cardArray.append(card)
            }
            array.append(cardArray)
            
        }
        array.remove(at: 0)
        print("Init OK")
        print(array)
        
        selectedItemsArray.append(array[0].first!)
        
    }
    
    static func addItemToSelected(item: CardModel) {
        if !selectedItemsArray.contains(where: {$0.id == item.id}) {
            selectedItemsArray.append(item)
            print("Add new item in SelectedArray")
        }
    }
    
    static func getCards(section: Int) -> [CardModel] {
        if array.count < 2 { //init at first start
            initArray()
        }
        print("getson num = " + String(section))
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

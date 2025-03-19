//
//  DM.swift
//  Helper
//
//  Created by Катерина Фоменко on 15/02/2025.
//

import Foundation
import SwiftUI

class DM: ObservableObject {
    @Published var isShowAddScreen: Bool = false
    
    @Published var selectedItemsArray: [CardModel] = [] // for top grid
    @Published var titleWay: String = "" // settings line
    
    @Published var parentCardsArray: [CardModel] = [] // source for perentElements from Json
    @Published var mainArray: [CardModel] = [] // monitor
    
    // хранится id карты на которую тапнули, если значение == -1 то показываем родительский массив иначе если больше нуля отображаются дочерние элементы
    var childCardIdOpened: Float = -1

    static let shared = DM()
    let textToSpeech = TextToSpeech()
    
    init() {
        
        loadData()
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
    
    func speakText(text: String) {
        //textToSpeech.speak(text: text, locale: "en-US")
        textToSpeech.speak(text: text, locale: "en-US", voiceIdentifier: "com.apple.speech.synthesis.voice.Fred")
    }

    private func loadData() {
        let array = UserSaving.shared.loadParentCardsArray()
        // load from UserDefaults
        if array.count > 0 {
            parentCardsArray = array
            mainArray = parentCardsArray
            addPlusCard()
            print("load from UserDefaults \(parentCardsArray.count)")
        } else {
            // load from JSON
            parentCardsArray = loadFromJSON()
            mainArray = parentCardsArray
            addPlusCard()
        }
    }
    
    func addPlusCard() {
        let cardPlus = CardModel(cardId: 102, title: "Plus", groupId: 102, imageName: "plus")
        if !mainArray.contains(cardPlus) {
            mainArray.append(cardPlus)
        }
        print("dm.parentCardsArray.append(cardPlus)")
    }
    
    func addHomeBackCards() {
        let cardHome = CardModel(cardId: 100, title: "Home", groupId: 100, imageName: "home4" )
        let cardBack = CardModel(cardId: 101, title: "Back", groupId: 101, imageName: "back1")
        
        mainArray.insert(cardHome, at: 0)
        mainArray.append(cardBack)
    }
    
    func addNewCard(name: String, selectedColorId: Int, imageName: String) {
        
        var newCard = CardModel(
            cardId: Float(parentCardsArray.count + 1),
            title: name,
            groupId: selectedColorId,
            imageName: imageName,
            priority: nil,
            childCards: nil
        )
        if childCardIdOpened > 0 {
            //add card to child card
             let number = getCardFromId(childCardIdOpened)
             let count = parentCardsArray[number].childCards?.count ?? 0
             newCard.cardId = Float(count) + 0.1
             parentCardsArray[number].childCards?.append(newCard)
             mainArray.insert(newCard, at: mainArray.count - 2)
            
             print("New card append to parent id = " + String(childCardIdOpened))
           
        } else {
            //add new card to main screen
            parentCardsArray.append(newCard)
            mainArray.insert(newCard, at: mainArray.count - 1)
        }
       
        UserSaving.shared.saveParentCardArray(parentCardsArray)
        print("🎞️ 🎞️ parentCardsArray добавили newCard: \( parentCardsArray.count)")
    }
    
    func getCardFromId(_ cardId: Float) -> Int {
        for (index, card) in parentCardsArray.enumerated() {
            if card.cardId == cardId {
                return index
            }
        }
        return 0
    }
    
    func getNameOfGroup() -> String {
        let number = getCardFromId(childCardIdOpened)
        let nameOfGroup = parentCardsArray[number].title
        return nameOfGroup
    }
    
    func getColorIdOfGroup() -> Int {
            let number = getCardFromId(childCardIdOpened)
            let colorIdGroup = parentCardsArray[number].groupId
            return colorIdGroup
    }
}





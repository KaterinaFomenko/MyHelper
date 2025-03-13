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
    
    @Published var parentCardsArray: [CardModel] = [] // source for perentElements from Json
    @Published var childCardsArray: [CardModel] = []  // source for childElements from Json
    
    var childCardIdOpened: Float = -1
    
    @Published var mainArray: [CardModel] = [] // monitor
    
    @Published var titleWay: String = ""
    
    @ObservedObject var userSaving = UserSaving()
    
    static let shared = DM()
    let textToSpeech = TextToSpeech()
    
    init() {
        //addPlusCard()
       // mainArray = parentCardsArray
        loadData()
       // addPlusCard()
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
    
    // check the first loaded
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
    
//    private func loadFromUserDefaults() {
//        userSaving.loadParentCardsArray()
//        print("🎞️ Загруженные карточки loadFromUserDefaults: \(mainArray.count)")
//    }
    
    func addPlusCard() {
        let cardPlus = CardModel(cardId: 102, title: "Plus", groupId: 102, imageName: "plus")
        if !mainArray.contains(cardPlus) {
            mainArray.append(cardPlus)
        }
        print("dm.parentCardsArray.append(cardPlus)")
    }
    
    func addNewCard(name: String, selectedColorId: Int, imageName: String) {
        
        let newCard = CardModel(
            cardId: Float(parentCardsArray.count + 1),
            title: name,
            groupId: selectedColorId,
            imageName: imageName,
            priority: nil,
            childCards: []
        )
        if childCardIdOpened > 0 {
            //add card to child card
            if #available(iOS 18.0, *) {
                let index = parentCardsArray.indices(where: {$0.cardId == childCardIdOpened})
                let number = index.ranges.first?.lowerBound ?? 0
                parentCardsArray[number].childCards?.append(newCard)
                print("New card append to parent id = " + String(childCardIdOpened))
            } else {
                // Fallback on earlier versions
            }
        } else {
            //add new card to main screen
            parentCardsArray.append(newCard)
        }
        UserSaving.shared.saveParentCardArray(parentCardsArray)
        print("🎞️ 🎞️ parentCardsArray добавили newCard: \( parentCardsArray.count)")
    }
    
    
    
}





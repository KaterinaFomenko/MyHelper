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
    
    @Published var mainArray: [CardModel] = [] // monitor
    
    @Published var titleWay: String = ""
    
    static let shared = DM()
    let textToSpeech = TextToSpeech()
    
    init() {
        loadParentCards()
        addPlusCard()
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
    
    func speakText(text: String) {
        //textToSpeech.speak(text: text, locale: "en-US")
        textToSpeech.speak(text: text, locale: "en-US", voiceIdentifier: "com.apple.speech.synthesis.voice.Fred")
    }
    
    private func loadParentCards() {
        parentCardsArray = load()
        print("🎞️ Загруженные карточки: \(parentCardsArray)")
    }
    
    private func addPlusCard() {
        let cardPlus = CardModel(cardId: 102, title: "Plus", groupId: 102, imageName: "plus")
            parentCardsArray.append(cardPlus)
            print("dm.parentCardsArray.append(cardPlus)")
    }
    
    func addNewCard(name: String, selectedColorId: Int, imageName: String) {
        
        // Преобразуем UIImage в base64 строку
        //let imageString = selectedImage?.jpegData(compressionQuality: 1.0)?.base64EncodedString() ?? ""

        let newCard = CardModel(
            cardId:  Float(parentCardsArray.count + 1),
            title: name,
            groupId: selectedColorId,
            imageName: imageName,
            priority: nil,
            childCards: [])
        
        parentCardsArray.append(newCard)
    }
   
    
    
}





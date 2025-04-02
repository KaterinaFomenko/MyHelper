//
//  DM.swift
//  Helper
//
//  Created by Катерина Фоменко on 15/02/2025.
//

import Foundation
import SwiftUI

 //Title for CreateNewCard
enum TitleState {
    case hasChildsCards
    case hasNotChildsCards
    case editingState
    
    var title: String {
        switch self {
        case .hasChildsCards: return "Create new Group"
        case .hasNotChildsCards: return "Create new Card"
        case .editingState: return "You may edit Card"
        }
    }
}

class DM: ObservableObject {
    static let shared = DM()
    
    @Published var mainArray: [CardModel] = [] // monitor
    @Published var parentCardsArray: [CardModel] = [] // source for perentElements from Json
    
    
    @Published var isStateEdiding: Bool = false
    @Published var isShowAddScreen: Bool = false
    @Published var isCardContainGroup = false // will card contain other cards into togle
    
    @Published var titleWay: String = "" // settings line
    @Published var selectedItemsArray: [CardModel] = [] // for top grid
    
    // хранится id карты на которую тапнули, если значение == -1 то показываем родительский массив иначе если больше нуля отображаются дочерние элементы
    var childCardIdOpened: Float = -1
    
    // хранится id карты на которую выделили для удаления / редактирования
    var selectedCardId: Float = 0
    let textToSpeech = TextToSpeech()
    
    init() {
        loadData()
    }
    
    func addItemToSelected(item: CardModel) {
        if !selectedItemsArray.contains(where: {$0.cardId == item.cardId}) {
            selectedItemsArray.append(item)
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
        let maxIdParent = parentCardsArray.map { $0.cardId }.max() ?? 99
        var newCard = CardModel(
            cardId: Float(maxIdParent + 1),
            title: name,
            groupId: selectedColorId,
            imageName: imageName,
            priority: nil,
            childCards: isCardContainGroup ? [] : nil
        )
        print("💁 Create new Id of parentCard \(newCard.cardId) ")
        
        if childCardIdOpened > 0 {
            //add card to child card
            let ind = getIndexFromCardId(childCardIdOpened)
            let maxId = parentCardsArray[ind].childCards?.map { $0.cardId }.max() ?? 99
            
            newCard.cardId = Float(maxId) + 0.1
            newCard.childCards = nil //  MARK: I add
            parentCardsArray[ind].childCards?.append(newCard)
            mainArray.insert(newCard, at: mainArray.count - 2)
            
        } else {
            //add new card to main screen
            parentCardsArray.append(newCard)
            mainArray.insert(newCard, at: mainArray.count - 1)
        }
        
        UserSaving.shared.saveParentCardArray(parentCardsArray)
        print("🎞️ 🎞️ parentCardsArray добавили newCard: \( parentCardsArray.count)")
    }
    
    func getNameOfGroup() -> String {
        let number = getIndexFromCardId(childCardIdOpened)
        let nameOfGroup = parentCardsArray[number].title
        print("☎️ childCardIdOpened: \(childCardIdOpened)")
        return nameOfGroup
    }
    
    func getColorIdOfGroup() -> Int {
        let number = getIndexFromCardId(childCardIdOpened)
        let colorIdGroup = parentCardsArray[number].groupId
        return colorIdGroup
    }
    
    func removeCurrentCard(_ cardId: Float) {
        for (index, card) in mainArray.enumerated() {
            if card.cardId == cardId {
                mainArray.remove(at: index)
            }
        }
    }
    
    // ищет индекс по Id
    func getIndexFromCardId(_ cardId: Float) -> Int {
        for (index, card) in parentCardsArray.enumerated() {
            if card.cardId == cardId {
                return index
            }
        }
        return 0
    }
    
    func getNameCardForEditing1(selectedCardId: Float) -> String {
        let ind = getIndexFromCardId(selectedCardId)
        return mainArray[ind].title // MARK: работает только родителей (для детей не ищет id )
    }
        
    func getNameCardForEditing(selectedCardId: Float) -> String {
        for (indexParent, cardParent) in parentCardsArray.enumerated() {
            if cardParent.cardId == selectedCardId {
                return parentCardsArray[indexParent].title
            }
            
            if let indexChild = cardParent.childCards?.firstIndex(where: { $0.cardId == selectedCardId }) {
                guard let childCardTitle = parentCardsArray[indexParent].childCards?[indexChild].title else { return "Something Wrong" }
                return childCardTitle
            }
        }
       return " DM. getNameCardForEditing "
    }
    
    func removeCardFromId(_ cardId: Float) {
        for (indexParent, cardParent) in parentCardsArray.enumerated() {
            if cardParent.cardId == cardId {
                parentCardsArray.remove(at: indexParent)
                mainArray.remove(at: indexParent)
                UserSaving.shared.saveParentCardArray(parentCardsArray)
                return
            }
            
            if let indChild = cardParent.childCards?.firstIndex(where: { $0.cardId == cardId } ) {
                parentCardsArray[indexParent].childCards?.remove(at: indChild)
                if mainArray.indices.contains(indChild) {
                    mainArray.remove(at: indChild + 1)
                }
                UserSaving.shared.saveParentCardArray(parentCardsArray)
                break
            }
        }
    }
    /// Возвращает локализованный заголовок в зависимости от состояния
    func titleState() -> String {
        if isStateEdiding {
            return TitleState.editingState.title
        }
        else {
            return isCardContainGroup ? TitleState.hasChildsCards.title : TitleState.hasNotChildsCards.title
        }
    }
}









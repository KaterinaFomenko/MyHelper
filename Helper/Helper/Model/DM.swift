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
    @Published var isShowCreateCardScreen: Bool = false
    @Published var isCardContainGroup = false // will card contain other cards into toggle
    
    @Published var titleWay: String = "" // settings line
    @Published var selectedItemsArray: [CardModel] = [] // for top grid
    
    // хранится id карты на которую тапнули, если значение == -1 то показываем родительский массив иначе если больше нуля отображаются дочерние элементы
    var parentCardIdOpened: Float = -1
    
    // хранится id карты на которую выделили для удаления / редактирования
    var contextCardId: Float = 0
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
        //print("dm.parentCardsArray.append(cardPlus)")
    }
    
    func addHomeBackCards() {
        let cardHome = CardModel(cardId: 100, title: "Home", groupId: 100, imageName: "home" )
        let cardBack = CardModel(cardId: 101, title: "Back", groupId: 101, imageName: "back1")
        mainArray.insert(cardHome, at: 0)
        mainArray.append(cardBack)
    }
    
    func getNameOfGroup() -> String {
        let number = getIndexFromCardId(parentCardIdOpened)
        let nameOfGroup = parentCardsArray[number].title
       // print("👇 parentCardIdOpened: \(nameOfGroup)")
        return nameOfGroup
    }
    
    func getColorIdOfGroup() -> Int {
        let number = getIndexFromCardId(parentCardIdOpened)
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
 
    // ищет индекс по Id (looking for Id for parent / child Cards)
    func getIndexFromCardId(_ cardId: Float) -> Int {
        for (indexParent, cardParent) in parentCardsArray.enumerated() {
            if cardParent.cardId == cardId {
               // print ("cardParent 💁💁: \(cardParent)")
                return indexParent
            }
            
            if let indexChild = cardParent.childCards?.firstIndex(where: { $0.cardId == cardId }) {
                //print ("cardChild 💁: \(cardParent.childCards?[indexChild].title):\(indexChild)")
                return indexChild
            }
        }
        return 0
    }
    
    func addNewCard(name: String, selectedColorId: Int, imageName: String?) {
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
        
        if parentCardIdOpened > 0 {
            //add card to child card
            let ind = getIndexFromCardId(parentCardIdOpened)
            let maxId = parentCardsArray[ind].childCards?.map { $0.cardId }.max() ?? parentCardIdOpened
            
            newCard.cardId = Float(maxId) + 0.1
            newCard.childCards = nil
            parentCardsArray[ind].childCards?.append(newCard)
            mainArray.insert(newCard, at: mainArray.count - 2)
            
        } else {
            //add new card to main screen
            parentCardsArray.append(newCard)
            mainArray.insert(newCard, at: mainArray.count - 1)
        }
        
        UserSaving.shared.saveParentCardArray(parentCardsArray)
    }
    
    // updateCard  Заменяем данные карточки на новые
    func updateCard(card: CardModel) {
        for (indexParent, cardParent) in parentCardsArray.enumerated() {
            if cardParent.cardId == card.cardId {
                print(parentCardsArray[indexParent])
                parentCardsArray[indexParent].title = card.title
                parentCardsArray[indexParent].groupId = card.groupId
                parentCardsArray[indexParent].imageName = card.imageName
                
                if isCardContainGroup == true && parentCardsArray[indexParent].childCards == nil {
                    parentCardsArray[indexParent].childCards = []
                }
                mainArray[indexParent] = parentCardsArray[indexParent]
            }
            // ToDo SaveChild
            if let indexChild = cardParent.childCards?.firstIndex(where: { $0.cardId == card.cardId }) {
               // if let childCard = parentCardsArray[indexParent].childCards?[indexChild] {
               //     print(childCard)
                parentCardsArray[indexParent].childCards?[indexChild].title = card.title
                parentCardsArray[indexParent].childCards?[indexChild].groupId = card.groupId
                parentCardsArray[indexParent].childCards?[indexChild].imageName = card.imageName
                if let card = parentCardsArray[indexParent].childCards?[indexChild] {
                    
                    mainArray[indexChild + 1] = card // in сhild array has HomeButton in the first place
                 }
               
            }
        }
        UserSaving.shared.saveParentCardArray(parentCardsArray)
    }
    
//    func updateChildIds(for parent: CardModel) {
//        guard let childCardsCount = parent.childCards else { return }
//        
//        for i in 0..<parent.childCardsCount.count {
//            
//        }
//    }
    
     // При редактировании карты
    func getCardByID(cardId: Float) -> CardModel? {
        for (indexParent, cardParent) in parentCardsArray.enumerated() {
            if cardParent.cardId == cardId {
                print(parentCardsArray[indexParent])
                return parentCardsArray[indexParent]
            }
            
            if let indexChild = cardParent.childCards?.firstIndex(where: { $0.cardId == cardId }) {
                if let childCard = parentCardsArray[indexParent].childCards?[indexChild] {
                    print(childCard)
                    return childCard
                }
            }
        }
        return nil
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
    
    func checkIsParent(id: Float) -> Bool { 
        for card in parentCardsArray {
            if card.cardId == id && card.childCards != nil {
                return true
            }
        }
        return false
    }
    
    
    
}










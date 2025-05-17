
//
//  NewCardsView.swift
//  Helper
//
//  Created by Катерина Фоменко on 03/03/2025.
//

import SwiftUI
import Photos

struct NewCardView: View {
    
    @EnvironmentObject var dm: DM
    @EnvironmentObject var settings: Settings
    
    @State private var nameCard: String = "" // TextField
    @State private var selectedColorId = 1 // color groupId
    @State private var selectedIconLibrary: String = ""
    @State private var selectedImageGalary: UIImage? = nil
    
    @State private var isPressedSaveBtn: Bool = false
    @State private var isAddingImageBtn: Bool = false
    @State private var isShowingImagePicker: Bool = false
    @State private var isShowIconLibrary: Bool = false
    
    // Alert
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var titleCard: LocalizedStringResource = ""
    
    var body: some View {
        ZStack {
            VStack() {
                VStack {
                    TitleCardView(title: titleCard)
    
                    HeaderSectionView(
                        nameCard: $nameCard,
                        selectedColorId: $selectedColorId,
                        selectedIconLibrary: $selectedIconLibrary,
                        selectedImageGalary: $selectedImageGalary,
                        isAddingImageBtn: $isAddingImageBtn,
                        isShowingImagePicker: $isShowingImagePicker,
                        isShowIconLibrary: $isShowIconLibrary
                    )
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                
                //MARK: Second half of the screen
                
                ListFormNewCardView(
                    nameCard: $nameCard,
                    selectedColorId: $selectedColorId
                )
                .listStyle(.inset)
                
                SaveButtonView(
                    isPressed: $isPressedSaveBtn,
                    isDisabled: !isNameValid(),
                    action: saveCard
                )
            }
        }
        
        .onAppear {
            selectedColorId = dm.getColorIdOfGroup(for: dm.parentCardIdOpened)
            dm.isCardContainGroup = dm.checkIsParent(id: dm.contextCardId)
            titleCard = dm.titleState() // update titleGroupe
            
            // MARK:  show new Card Screen for editind
            
            if dm.isStateEdiding == true {
                
                selectedColorId = dm.getColorIdOfGroup(for: dm.contextCardId)
                
                let nameCardTranslate = dm.getCardByID(cardId: dm.contextCardId)?.titleKey ?? "Empty name"
                let lang = settings.storedLanguage
                nameCard =  nameCardTranslate.getLocalizedString(language: lang )
                
                let imageName = dm.getCardByID(cardId: dm.contextCardId)?.imageName ?? "scribble"
                
                if let image = ImageService.shared.loadImageFromDiskWith(fileName: imageName) {
                    selectedImageGalary = image
                    
                } else {
                    selectedImageGalary = UIImage(named: imageName)
                }
            }
        }
        // при закрытии окна режим редактирования = false
        .onDisappear {
            dm.isStateEdiding = false
            dm.isCardContainGroup = false
            dm.contextCardId = 0
        }
        // Open Galery
        .sheet(isPresented: $isShowingImagePicker) {
            ImagePicker(selectedImage: $selectedImageGalary)
        }
        
        .modifier(
            AlertModifier(
                showAlert: $showAlert,
                alertMessage: alertMessage
            )
        )
    }
    
    private func isNameValid() -> Bool {
        let trimmedName = nameCard.trimmingCharacters(in: .whitespaces)
        return !trimmedName.isEmpty
    }
    
    private func maxChildId(for parentId: Float, array: [CardModel]) -> Float {
        guard let parent = array.first(where: { $0.cardId == parentId }),
              let children = parent.childCards, !children.isEmpty else { return  parentId }
        
        return children.max(by: { $0.cardId < $1.cardId })?.cardId ?? parentId
    }
    
    private func saveCard() {
        guard isNameValid() else {
            showAlert(message: "Name cannot be empty")
            return
        }
        
        var imageName: String? = nil
        var maxId: Float = 0
        
        // Режим редактирования: используем существующий ID
        if dm.isStateEdiding {
            maxId = dm.contextCardId
            print("⚒️ Редактирование карточки ID: \(dm.contextCardId)")
        } else {
            
            // Режим создания новой карты
            if dm.parentCardIdOpened < 0 {
                // Создаем родительскую карточку
                maxId  = dm.parentCardsArray.max(by: { $0.cardId < $1.cardId })?.cardId ??  1
                maxId = maxId + 1
            } else {
                // Создаем дочернюю карточку
                let parentId = Float(dm.parentCardIdOpened)
                print(parentId)
                maxId = maxChildId(for: dm.parentCardIdOpened, array: dm.parentCardsArray)
                maxId = maxId + 0.1
                print(maxId)
            }
        }
        // Сохранение изображения и присвоение имени
        if !selectedIconLibrary.isEmpty {
            imageName = selectedIconLibrary
            print("⚒️ Создана selectedIconLibrary с именем ID: \(imageName!)")
        } else if let image = selectedImageGalary {
            let randomValue = Float.random(in: 0.0...0.1000)
            imageName = "img_\(maxId + randomValue)"
            ImageService.shared.saveImage(imageName: imageName, image: image)
            print("⚒️ Создана selectedImageGalary с именем ID: \(imageName!))")
            
        } else {
            imageName = "text.below.photo"
        }
        
        let card = CardModel(
            cardId: dm.contextCardId,
            titleKey: nameCard,
            groupId: selectedColorId,
            imageName: imageName,
            priority: nil)
        
        if dm.isStateEdiding {
            dm.updateCard(card: card)
        } else {
            dm.addNewCard(
                name: nameCard,
                selectedColorId: selectedColorId,
                imageName: imageName
            )
        }
        dm.isShowCreateCardScreen = false
    }
    
    private func showAlert(message: String) {
        alertMessage = message
        showAlert = true
    }
}

#Preview("state editing") {
    let testSpeechManager = SpeechManager(lang: Settings().storedLanguage)
    let dm = DM(speechManager: testSpeechManager)
    let settings = Settings()
    dm.isStateEdiding = true
    return NewCardView()
        .environmentObject(dm)
        .environmentObject(testSpeechManager)
        .environmentObject(settings)
}

#Preview("state general") {
    let testSpeechManager = SpeechManager(lang: Settings().storedLanguage)
    let dm = DM(speechManager: testSpeechManager)
    let settings = Settings()
    dm.isStateEdiding = false
    return NewCardView()
        .environmentObject(dm)
        .environmentObject(testSpeechManager)
        .environmentObject(settings)
}


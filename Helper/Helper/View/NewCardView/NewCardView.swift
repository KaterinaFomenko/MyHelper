
//
//  NewCardsView.swift
//  Helper
//
//  Created by Катерина Фоменко on 03/03/2025.
//

import SwiftUI
import Photos

struct NewCardView: View {
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @EnvironmentObject var dm: DM
    @EnvironmentObject var settings: Settings
    @EnvironmentObject var coordinator: NavigationCoordinator
    
    var card: CardModel
    @State private var titleCard: LocalizedStringResource = ""
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
    
    // keyboard
    @StateObject private var keyboardState = KeyboardState()
    
    var isLandscape: Bool {
        UIDevice.current.orientation.isLandscape
    }
    
    var isTabletLayout: Bool {
        horizontalSizeClass == .regular && verticalSizeClass == .regular
    }
    
    init(card: CardModel) {
        self.card = card
        _selectedColorId = State(initialValue: card.groupId)
    }
    
    var body: some View {
        
        Group {
            if isTabletLayout && isLandscape {
                HStack(spacing: 5) {
                    leftSection
                    VStack {
                        titleCardView
                        rightSection
                    }
                }
                
            } else {
                VStack() {
                    leftSection
                    titleCardView
                     //   .scaleEffect(keyboardState.keyboardHeight > 0 ? 0.55 : 1.0)
                     //   .animation(.easeInOut(duration: 0.3), value: keyboardState.keyboardHeight)
                    rightSection
                }
            }
        }
        .environmentObject(keyboardState)
        .background(Color.gray.opacity(0.1))
        .listStyle(.inset)
        .onAppear {
            selectedColorId = dm.getColorIdOfGroup(for: Float(card.groupId))
            
            dm.isCardContainGroup = dm.checkIsParent(id: card.cardId)
            titleCard = dm.titleState() // update titleGroupe
            
            // if state editing
            
            if dm.isStateEdiding == true {
                
                selectedColorId = dm.getColorIdOfGroup(for: card.cardId)
                
                let nameCardTranslate = card.titleKey
                let lang = settings.storedLanguage
                nameCard =  nameCardTranslate.getLocalizedString(language: lang )
                
                let imageName = dm.getCardByID(cardId: card.cardId)?.imageName ?? "scribble"
                
                if let image = ImageService.shared.loadImageFromDiskWith(fileName: imageName) {
                    selectedImageGalary = image
                    
                } else {
                    selectedImageGalary = UIImage(named: imageName)
                }
            }
        }
        
        // when the screen is closed: isStateEdiding = false
        .onDisappear {
            dm.isStateEdiding = false
            dm.isCardContainGroup = false
            dm.contextCardId = 0
        }
        // open Galery
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
    
    
    private var leftSection: some View {
        HeaderSectionView(
            nameCard: $nameCard,
            selectedColorId: $selectedColorId,
            selectedIconLibrary: $selectedIconLibrary,
            selectedImageGalary: $selectedImageGalary,
            isAddingImageBtn: $isAddingImageBtn,
            isShowingImagePicker: $isShowingImagePicker,
            isShowIconLibrary: $isShowIconLibrary
        )
        //     уменьшаем в 2 раза при появлении клавиатуры
        .scaleEffect(keyboardState.keyboardHeight > 0 ? 0.55 : 1.0)
        .animation(.easeInOut(duration: 0.3), value: keyboardState.keyboardHeight)
    }
    
    private var titleCardView: some View {
        TitleCardView(title: titleCard)
            .padding(.top, -AppSize.buttonPadding)
        
//        if isTabletLayout == true {
//            .scaleEffect(keyboardState.keyboardHeight > 0 ? 0.55 : 1.0)
//            .animation(.easeInOut(duration: 0.3), value: keyboardState.keyboardHeight)
//        }
    }
    
    private var rightSection: some View {
        VStack {
                ListFormNewCardView(
                    nameCard: $nameCard,
                    selectedColorId: $selectedColorId
                )
                .padding(.horizontal, AppSize.buttonPadding)
            
                if keyboardState.keyboardHeight == 0 {
                    SaveButtonView(
                        isPressed: $isPressedSaveBtn,
                        isDisabled: !isNameValid(),
                        action: saveCard
                    )
                    .padding(AppSize.buttonPadding) // for btn save
                }
        }
    }
  
    private func maxChildId(for parentId: Float, array: [CardModel]) -> Float {
        guard let parent = array.first(where: { $0.cardId == parentId }),
              let children = parent.childCards, !children.isEmpty else { return  parentId }
        
        return children.max(by: { $0.cardId < $1.cardId })?.cardId ?? parentId
    }
    
    
    private func isNameValid() -> Bool {
        let trimmedName = nameCard.trimmingCharacters(in: .whitespaces)
        return !trimmedName.isEmpty
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
            
       //   maxId = dm.contextCardId
            maxId = card.cardId
            
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
        //dm.isShowCreateCardScreen = false
        coordinator.path.removeLast(coordinator.path.count)
    }
    
    private func showAlert(message: String) {
        alertMessage = message
        showAlert = true
    }
}

struct NewCardView_Previews: PreviewProvider {
    static var previews: some View {
        let testCard = CardModel(
            cardId: 1,
            titleKey: "Test Card",
            groupId: 1,
            imageName: "scribble",
            priority: nil
        )
        
        let keyboardState = KeyboardState()
        let testSpeechManager = SpeechManager(lang: Settings().storedLanguage)
        let dm = DM(speechManager: testSpeechManager)
        let settings = Settings()
        
        // Preview для режима редактирования
        Group {
            NewCardView(card: testCard)
                .environmentObject(dm)
                .environmentObject(settings)
                .environmentObject(keyboardState)
                .previewDisplayName("Edit Mode")
                .onAppear {
                    dm.isStateEdiding = true
                    dm.contextCardId = testCard.cardId
                }
            
        // Preview для режима создания новой карточки
            NewCardView(card: testCard)
                .environmentObject(dm)
                .environmentObject(settings)
                .environmentObject(keyboardState)
                .previewDisplayName("Create Mode")
                .onAppear {
                    dm.isStateEdiding = false
                    dm.parentCardIdOpened = -1
                }
        }
    }
}

//
//  NewCardView 2.swift
//  Helper
//
//  Created by Катерина Фоменко on 24/04/2025.
//


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
    
    @State private var nameCard: String = "" // имя
    @State private var selectedColorId = 1 // цвет groupId
    @State private var selectedIconLibrary: String = ""
    @State private var selectedImageGalary: UIImage? = nil
    
    
    @State private var isSavingBtn: Bool = false
    @State private var isAddingImageBtn: Bool = false
    @State private var isShowingImagePicker = false
     // выбранная картинка с Галереи
    @State private var isShowIconLibrary: Bool = false
    
    // Alert
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var titleCard: LocalizedStringResource = ""
    
    var body: some View {
        ZStack {
            VStack() {
                HStack {
                    
                    if dm.parentCardIdOpened < 0 {
                        Text(titleCard)
                            .transition(.opacity)
                            .id("TextIdentifier_\(dm.isCardContainGroup)")
                    } else {
                        Text(dm.getNameOfGroup())
                            .lineLimit(1)
                            .truncationMode(.tail) // Добавляем многоточие в конце
                    }
                }
                .font(.custom("Helvetica Neue", size: 20))
                .foregroundStyle(.gray)
                .animation(.snappy , value: dm.isCardContainGroup)
                
                GeometryReader { geometry in
                    ZStack(alignment: .center) {
                        
                        // MARK: Big rectangle change color
                        ZStack {
                            Rectangle()
                                .fill(AppColors.getColor(groupId: selectedColorId))
                                .opacity(0.5)
                                .frame(width: geometry.size.width / 1.35, height: geometry.size.width / 1.35)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                            
                            VStack {
                                
                                Text(nameCard)
                                    .font(.custom("Helvetica Neue", size: 30))
                                    .lineLimit(1) // Ограничиваем одной строкой
                                    .truncationMode(.tail) // Добавляем многоточие в конце
                                    .frame(maxWidth: geometry.size.width / 1.5)
                                    .padding(.top, 10)
                                    
                                    
                                
                                Spacer()
                                
                                HStack {
                                    
                                   // if dm.isStateEdiding {
                                        
                                        Menu {
                                            ControlGroup {
                                                Button {
                                                    isShowIconLibrary = true
                                                } label: {
                                                    Label("Icon Library", systemImage:   "square.3.layers.3d.down.right")
                                                    
                                                }
                                                
                                                Button {
                                                    pickPhoto()
                                                } label: {
                                                    Label("Foto Galary", systemImage:  "camera")
                                        
                                                }
                                            }
                                            
                                        } label: {
                                            Label("more", systemImage: "ellipsis.circle")
                                                .labelStyle(.iconOnly)
                                                .shadow(radius: 10)
                                        }
                              //      }
                                        
                                    Spacer()
                                    
                                  //  if (dm.parentCardIdOpened < 0) {
                                        Image(systemName: "circle.fill")
                                            .resizable()
                                            .frame(width: 5, height: 5)
                                            .foregroundColor(dm.isCardContainGroup ? .blue : .clear)
                                            .padding(.horizontal, 5)
                                            .shadow(radius: 10)
                                            .opacity(0.5)
                                         //   .padding(.top, 40)
                                 //   }
                                }
                                .sheet(isPresented: $isShowIconLibrary) {
                                    IconLibraryView(isShowIconGalary: $isShowIconLibrary, selectedIconLibrary: $selectedIconLibrary)
                                }
                            }
                            .frame(width: geometry.size.width / 1.5, height: geometry.size.width / 1.5)
                        }
                        displayImageOrButton(geometry: geometry)
                    }
                }
            }
            .padding()
        }
        .background(Color.gray.opacity(0.1))
        
        //MARK: Second half of the screen
        
        List {
            VStack(alignment: .leading) {
                Text("Name")
                    .font(.headline)
                TextField("Enter name", text: $nameCard)
            }
            
            HStack(alignment: .center) {
                Text("Color")
                    .font(.headline)
                CustomColorPicker(selectedColorId: $selectedColorId)
            }
            
            if ( dm.parentCardIdOpened < 0 ) {
                
                Toggle("Will the card contain other cards ?", isOn: $dm.isCardContainGroup)
                    .font(.custom("Helvetica Neue", size: 20))
                    .foregroundStyle(.gray)
                    .animation(.snappy, value: dm.isCardContainGroup)
                    .padding(.top)
                    .disabled(dm.checkIsParent(id: dm.contextCardId) && dm.isStateEdiding)
            }
        }
        
        .onAppear {
           
            selectedColorId = dm.getColorIdOfGroup(for: dm.parentCardIdOpened)
        
            dm.isCardContainGroup = dm.checkIsParent(id: dm.contextCardId)
            
            titleCard = dm.titleState() // update titleGroupe
            
            // MARK:  show new Card Screen for editind
            
            if dm.isStateEdiding == true {
              
                selectedColorId = dm.getColorIdOfGroup(for: dm.contextCardId)
                
                nameCard = dm.getCardByID(cardId: dm.contextCardId)?.titleKey ?? "Empty name"
                
                let imageName = dm.getCardByID(cardId: dm.contextCardId)?.imageName ?? "scribble"
                
                if let image = ImageService.shared.loadImageFromDiskWith(fileName: imageName) {
                    selectedImageGalary = image
                    
                } else {
                    selectedImageGalary = UIImage(named: imageName) // или ???
                    //selectedIconLibrary = imageName
                }
            }
        }
        // при закрытии окна режим редактирования = false
        .onDisappear {
            dm.isStateEdiding = false
            dm.isCardContainGroup = false
            dm.contextCardId = 0
        }
        .listStyle(.inset)
        
        Button {
            isSavingBtn.toggle()
            
            saveCard()
            
        } label: {
            Text("Save")
                .frame(minWidth: 80)
                .modifier(
                    CustomButtonModifier(
                        isPressed: isSavingBtn,
                        backgroundColor: nameCard.isEmpty ? .grayLight1 : .blue,
                        textColor: nameCard.isEmpty ? .black : .white
                    )
                )
        }
        .disabled(!isNameValid())
        .padding(.bottom)
        
        // Open Galery
        .sheet(isPresented: $isShowingImagePicker) {
            ImagePicker(selectedImage: $selectedImageGalary)
        }
        // Alert
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Warning"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    private func requestPhotoLibraryAccess(completion: @escaping (Bool) -> Void) {
        PHPhotoLibrary.requestAuthorization { status in
            DispatchQueue.main.async {
                switch status {
                case .authorized, .limited:
                    completion(true)
                case .denied, .restricted, .notDetermined:
                    completion(false)
                @unknown default:
                    completion(false)
                }
            }
        }
    }
    
    private func pickPhoto() {
        print("Pressed BTN pickPhoto")
        requestPhotoLibraryAccess { granted in
            if granted {
                isShowingImagePicker = true
            } else {
                print("Доступ к галерее не предоставлен")
            }
        }
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
    // MARK: Todo refactor condition
    
    @ViewBuilder
    private func displayImageOrButton(geometry: GeometryProxy) -> some View {
        // MARK: place show Galary
        if !selectedIconLibrary.isEmpty {
      
            Image(selectedIconLibrary)
                .resizable()
                .scaledToFit()
                .frame(width: geometry.size.width / 2, height: geometry.size.width / 2)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(.top, 50)
            
        } else if let selectedImageGalary = selectedImageGalary {
            Image(uiImage: selectedImageGalary)
                .resizable()
                .scaledToFill()
                .frame(width: geometry.size.width / 2, height: geometry.size.width / 2)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .offset(y: 20)
        } else {
            Button(action: {
                isAddingImageBtn.toggle()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    withAnimation {
                        isAddingImageBtn = true
                    }
                    print("👇 Tapped add new image")
                    pickPhoto()
                }
            }) {
                Text("Add image") // Blue Button
                    .modifier(
                        CustomButtonModifier(
                            isPressed: isAddingImageBtn,
                            backgroundColor: .blue,
                            textColor: .white
                        )
                    )
            }
            .zIndex(2)
        }
    }
}

#Preview("state editing") {
    let testSpeechManager = SpeechManager(settings: Settings())
    let dm = DM(speechManager: testSpeechManager)
    dm.isStateEdiding = true
    return NewCardView()
            .environmentObject(dm)
            .environmentObject(testSpeechManager)
}

#Preview("state general") {
    let testSpeechManager = SpeechManager(settings: Settings())
    let dm = DM(speechManager: testSpeechManager)
    dm.isStateEdiding = false
    return NewCardView()
            .environmentObject(dm)
            .environmentObject(testSpeechManager)
}


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
   // @State private var colorOfGroupId  = 1 // цвет группы
    @State private var selectedIcon: String? = nil // выбранная иконка
    
    @State private var isSavingBtn: Bool = false
    @State private var isAddingImageBtn: Bool = false
    @State private var isShowingImagePicker = false
    @State private var selectedImage: UIImage? = nil  // выбранная картинка с Галереи
    
    // Alert
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var titleCard = ""
    
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
                                    .padding(.top, 10)
                                    .frame(maxWidth: geometry.size.width / 1.5 - 40)
                                
                                Spacer()
                                
                                HStack {
                                    
                                   //   if (dm.isCardContainGroup && dm.parentCardIdOpened < 0)  {
                                    if dm.isStateEdiding {
                                        
                                        Button("", systemImage: "pencil.circle") {
                                            pickPhoto()
                                        }
                                        .font(.title)
                                        .foregroundStyle(.black)
                                          }
                                        Spacer()
                                        //if (dm.isCardContainGroup && dm.parentCardIdOpened > 0) || dm.isStateEdiding {
                                        // если создаю родительскую карточку:   false && -1.0 > 0 (false)
                                   
                                        if (dm.isCardContainGroup && dm.parentCardIdOpened < 0) {
                                            Label("This is Grope", systemImage: "ellipsis")
                                                .labelStyle(.iconOnly)
                                        }
                                  //  }
                                }
                            }
                            .frame(width: geometry.size.width / 1.5, height: geometry.size.width / 1.5)
                        }
                        
                        if let selectedImage = selectedImage {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: geometry.size.width / 2, height: geometry.size.width / 2)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .offset(y: 20)
                            
                        } else {
                            Button {
                                isAddingImageBtn.toggle()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    withAnimation {
                                        isAddingImageBtn = true
                                    }
                                    print ("👇 Tapped add new image")
                                    pickPhoto()
                                }
                            } label: {
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
            
            //(dm.isCardContainGroup && dm.parentCardIdOpened > 0)
            // MARK: Toogle // add 10.04 && dm.isStateEdiding == false
            // if dm.parentCardIdOpened < 0 && dm.isStateEdiding == false {
            
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
            selectedColorId = dm.getColorIdOfGroup()
            //  selectedColorId = dm.getCardByID(cardId: dm.selectedCardId)?.groupId ?? 1
           
            dm.isCardContainGroup = dm.checkIsParent(id: dm.contextCardId) // Bool
            // dm.isCardContainGroup = false
            
            titleCard = dm.titleState() // update titleGroupe
            
            // MARK:  show new Card Screen for editind
            
            if dm.isStateEdiding == true {
                nameCard = dm.getCardByID(cardId: dm.contextCardId)?.title ?? "Empty name"
                
                let imageName = dm.getCardByID(cardId: dm.contextCardId)?.imageName ?? "ball"
                // let color = dm.getCardByID(cardId: dm.selectedCardId)?.groupId ?? 0
                
                if let image = ImageService.shared.loadImageFromDiskWith(fileName: imageName) {
                    selectedImage = image
                    
                } else {
                    selectedImage = UIImage(named: imageName)
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
            ImagePicker(selectedImage: $selectedImage)
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
        
        if dm.isStateEdiding {
            // Режим редактирования: используем существующий ID
            //imageName = "img_\(dm.contextCardId)"
            maxId = dm.contextCardId
            print("⚒️ Редактирование карточки ID: \(dm.contextCardId)")
        } else {
            
                // Режим создания новой карты
            if dm.parentCardIdOpened < 0 {
                // Создаем родительскую карточку
                maxId  = dm.parentCardsArray.max(by: { $0.cardId < $1.cardId })?.cardId ??  1
                maxId = maxId + 1
                //imageName = "img_\(maxIdParent + 1)"
               
            } else {
                // Создаем дочернюю карточку
                let parentId = Float(dm.parentCardIdOpened)
                print(parentId)
                maxId = maxChildId(for: dm.parentCardIdOpened, array: dm.parentCardsArray)
                maxId = maxId + 0.1
                print(maxId)
            }
    }
        // Сохранение изображения
        if let image = selectedImage {
            imageName = "img_\(maxId)"
            ImageService.shared.saveImage(imageName: imageName, image: image)
            print("⚒️ Создана картинка с именем ID: \(String(describing: imageName))")
        }
        
        let card = CardModel(
            cardId: dm.contextCardId,
            title: nameCard,
            groupId: selectedColorId,
            imageName: imageName)
        
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
#Preview {
    NewCardView()
        .environmentObject(DM())
}


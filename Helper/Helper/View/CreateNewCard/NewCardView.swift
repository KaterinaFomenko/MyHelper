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
    @State private var selectedColorId = 1 // цвет
    @State private var colorOfGroupId  = 1 // цвет группы
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
               //     Spacer()
//                    Button("", systemImage: "pencil") {
//                        print("Tapped Edit")
//                        // ToDo editing image
//                    }
//                    .font(.largeTitle)
//                    .foregroundStyle(.black)
             
                    if dm.childCardIdOpened < 0 {
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
            //    Spacer()
                
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
                                if dm.isCardContainGroup && dm.childCardIdOpened < 0 {
                                    HStack {
                                        Spacer()
                                        Label("This is Grope", systemImage: "ellipsis")
                                            .labelStyle(.iconOnly)
                                    }
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
            
            // MARK: Toogle
            if dm.childCardIdOpened < 0 {
                Toggle("Will the card contain other cards ?", isOn: $dm.isCardContainGroup)
                    .font(.custom("Helvetica Neue", size: 20))
                    .foregroundStyle(.gray)
                    .animation(.snappy, value: dm.isCardContainGroup)
                    .padding(.top)
            }
        }
        .onAppear {
            selectedColorId = dm.getColorIdOfGroup()
          //  selectedColorId = dm.getCardByID(cardId: dm.selectedCardId)?.groupId ?? 1
            titleCard = dm.titleState() // update titleGroupe
           
            // MARK:  show new Card Screen for editind
            
            if dm.isStateEdiding == true {
                nameCard = dm.getCardByID(cardId: dm.selectedCardId)?.title ?? "Empty name"
                
                let imageName = dm.getCardByID(cardId: dm.selectedCardId)?.imageName ?? "ball"
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
    
    private func saveCard() {
        guard isNameValid() else {
            showAlert(message: "Name cannot be empty")
            return
        }
        var imageName = ""
        var maxId: Float = 1
        
        
        if dm.isStateEdiding == false {
            
            // State_ add new Card
           
            if dm.childCardIdOpened < 0 {
                maxId = dm.mainArray.dropLast().max { $0.cardId < $1.cardId }?.cardId ?? 1
                
            } else {
                //var count = dm.mainArray.count - 2
                maxId = dm.mainArray.dropLast(2).max { $0.cardId < $1.cardId }?.cardId ?? 1
            }
           
            dm.selectedCardId = maxId + 1
            imageName = "img_" + String(dm.selectedCardId)
            print("⚒️ State_ create <new Card>, save imageName: \(imageName)")
            
        } else {
            // State_ edit Card
            imageName = "img_" + String(dm.selectedCardId)  // nameCard by Id
            print("⚒️ State_ edit Card: \(imageName)")
        }
        
        if let image = selectedImage {
            ImageService.shared.saveImage(imageName: imageName, image: image)
        }
        
        if dm.isStateEdiding {
            let card = CardModel(cardId: dm.selectedCardId, title: nameCard, groupId: selectedColorId, imageName: imageName)
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


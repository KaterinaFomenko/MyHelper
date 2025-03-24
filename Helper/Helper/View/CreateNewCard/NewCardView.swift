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
    
    @State private var isPressedSaveBtn: Bool = false
    @State private var isPressedAddImageBtn: Bool = false
    //@State private var isShowChildScreen: Bool = false
    @State private var isShowingImagePicker = false
    @State private var selectedImage: UIImage? = nil  // выбранная картинка с Галереи
    
    // Alert
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        ZStack {
            VStack() {
                HStack {
                    Button("", systemImage: "pencil") {
                        print("Tapped Edit")
                        // ToDo editing image
                    }
                    .font(.largeTitle)
                    .foregroundStyle(.black)
                    Spacer()
                    if dm.childCardIdOpened < 0 {
                        Text(dm.isCardContainGroup ? "Create new Groupe" : "Create new Card")
                        .font(.custom("Helvetica Neue", size: 20))
                            .foregroundStyle(.gray)
                            .transition(.opacity)
                            .id("TextIdentifier_\(dm.isCardContainGroup)")
                            .offset(x: -20)
                            
                        Spacer()
                        
                    } else {
                        Text(dm.getNameOfGroup())
                            .font(.custom("Helvetica Neue", size: 20))
                            .lineLimit(1) // Ограничиваем одной строкой
                            .truncationMode(.tail) // Добавляем многоточие в конце
                            .foregroundStyle(.gray)
                            .offset(x: -20)
                        Spacer()
                    }
                }
                .animation(.snappy , value: dm.isCardContainGroup)
                Spacer()
                
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
                                isPressedAddImageBtn.toggle()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    withAnimation {
                                        isPressedAddImageBtn = true
                                    }
                                    print ("👇 Tapped add new image")
                                    pickPhoto()
                                }
                            } label: {
                                Text("Add image") // Blue Button
                                    .modifier(
                                        CustomButtonModifier(
                                            isPressed: isPressedAddImageBtn,
                                            backgroundColor: .blue,
                                            textColor: .white
                                        )
                                    )
                                    
                                    //.foregroundStyle(.white)
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
                // CustomColorPicker(selectedColorId: dm.childCardIdOpened)
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
        }
        .listStyle(.inset)
        
        Button {
            isPressedSaveBtn.toggle()
            checkUniqName()
            //dm.isShowAddScreen = false
        } label: {
            Text("Save")
                .modifier(
                    CustomButtonModifier(
                        isPressed: isPressedSaveBtn,
                        backgroundColor: nameCard.isEmpty ? .grayLight1 : .blue,
                        textColor: nameCard.isEmpty ? .black : .white
                    )
                )
        }
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
    
    private func checkUniqName() {
        if nameCard.isEmpty {
            showAlert(message: "Please enter name")
            return
        }
        
        var isUnique: Bool = true
        
        for card in dm.mainArray {
            //check parent title
            if card.title == nameCard {
                isUnique = false
            }
        }
        if !isUnique {
            showAlert(message: "Please enter a unique name: \(nameCard)")
            return
        }
        
        let imageName = nameCard
        ImageService.shared.saveImage(imageName: imageName, image: selectedImage ?? UIImage())
        
        dm.addNewCard(
            name: nameCard,
            selectedColorId: selectedColorId,
            imageName: imageName
        )
        dm.isShowAddScreen = false
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


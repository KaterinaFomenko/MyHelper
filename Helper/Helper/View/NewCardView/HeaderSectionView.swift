//
//  HeaderNewCardViewView.swift
//  Helper
//
//  Created by Катерина Фоменко on 17/05/2025.
//

import SwiftUI
import Photos

struct HeaderSectionView: View {
    
    @EnvironmentObject var dm: DM
    @EnvironmentObject var keyboardState: KeyboardState

    @Binding var nameCard: String  // TextField
    @Binding var selectedColorId: Int // color groupId
    @Binding var selectedIconLibrary: String
    @Binding var selectedImageGalary: UIImage?
   
    @Binding var isAddingImageBtn: Bool
    @Binding var isShowingImagePicker: Bool
    @Binding var isShowIconLibrary: Bool
    
    var body: some View {
       
                GeometryReader { geometry in
                    ZStack(alignment: .center) {
                        
                        // MARK: Big rectangle change color
                        ZStack {
                            Rectangle()
                                .fill(AppColors.getColor(groupId: selectedColorId))
                                .opacity(0.5)
                                .frame(width: geometry.size.width / 1.35, height: geometry.size.width / 1.35)
                                .clipShape(RoundedRectangle(cornerRadius: AppSize.cornerRadius))
                                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                            
                            VStack {
                                
                                Text(nameCard.lkey)
                                    .font(.custom(AppSize.fontFamily, size:AppSize.titleFont))
                                    .lineLimit(1)
                                    .truncationMode(.tail) // Добавляем многоточие в конце
                                    .frame(maxWidth: geometry.size.width / 1.5)
                                  //  .padding(10)
                                
                                Spacer()
                                
                                HStack {
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
                                        if keyboardState.keyboardHeight == 0 {
                                            Label("more", systemImage: "ellipsis.circle")
                                                .labelStyle(.iconOnly)
                                                .shadow(radius: 10)
                                        }
                                    }
                                    Spacer()
                                    
                                        Image(systemName: "circle.fill")
                                            .resizable()
                                            .frame(width: AppSize.groupeIconSize, height: AppSize.groupeIconSize)
                                            .foregroundColor(dm.isCardContainGroup ? .blue : .clear)
                                            .padding(.horizontal, 5)
                                            .shadow(radius: 10)
                                            .opacity(0.5)
                                }
                                .sheet(isPresented: $isShowIconLibrary) {
                                    IconLibraryView(isShowIconGalary: $isShowIconLibrary, selectedIconLibrary: $selectedIconLibrary)
                                }
                            }
                            .frame(width: geometry.size.width / 1.5, height: geometry.size.width / 1.5)
                        }
                        
                        // MARK: place show Galary
                        if !selectedIconLibrary.isEmpty {
                            
                            Image(selectedIconLibrary)
                                .resizable()
                                .scaledToFit()
                                .frame(width: geometry.size.width / 2, height: geometry.size.width / 2)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                              //  .padding(.top, 50)
                              
                            
                        } else if let selectedImageGalary = selectedImageGalary {
                            Image(uiImage: selectedImageGalary)
                                .resizable()
                                .scaledToFill()
                                .frame(width: geometry.size.width / 2, height: geometry.size.width / 2)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                              //  .offset(y: 20)
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
        // уменьшаем в 2 раза при появлении клавиатуры
                .scaleEffect(keyboardState.keyboardHeight > 0 ? 0.75 : 1.0)
                .animation(.easeInOut(duration: 0.3), value: keyboardState.keyboardHeight)
                .padding()
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
}

#Preview("Library") {
    var keyboardState = KeyboardState()
    let testSpeechManager = SpeechManager(lang: Settings().storedLanguage)
    let dm = DM(speechManager: testSpeechManager)
    
    HeaderSectionView(
        nameCard: .constant("Animals"),
        selectedColorId: .constant(2),
        selectedIconLibrary: .constant("tooth"),
        selectedImageGalary: .constant(nil),
        isAddingImageBtn: .constant(false),
        isShowingImagePicker: .constant(false),
        isShowIconLibrary: .constant(false)
    )
            .environmentObject(dm)
            .environmentObject(keyboardState)
}

#Preview("Galary") {
    var keyboardState = KeyboardState()
    let testSpeechManager = SpeechManager(lang: Settings().storedLanguage)
    let dm = DM(speechManager: testSpeechManager)
    
    let testImage = UIImage(systemName: "sun.max.fill")
    
    HeaderSectionView(
        nameCard: .constant("Nature"),
        selectedColorId: .constant(3),
        selectedIconLibrary: .constant(""),
        selectedImageGalary: .constant(testImage),
        isAddingImageBtn: .constant(false),
        isShowingImagePicker: .constant(false),
        isShowIconLibrary: .constant(false)
    )
            .environmentObject(dm)
            .environmentObject(keyboardState)
}

#Preview("With Add Button") {
    var keyboardState = KeyboardState()
    let testSpeechManager = SpeechManager(lang: Settings().storedLanguage)
    let dm = DM(speechManager: testSpeechManager)
    
    HeaderSectionView(
        nameCard: .constant("Travel"),
        selectedColorId: .constant(4),
        selectedIconLibrary: .constant(""),
        selectedImageGalary: .constant(nil),
        isAddingImageBtn: .constant(false),
        isShowingImagePicker: .constant(false),
        isShowIconLibrary: .constant(false)
    )
    .environmentObject(dm)
    .environmentObject(keyboardState)
}

//
//  ListFormNewCardView.swift
//  Helper
//
//  Created by Катерина Фоменко on 17/05/2025.
//

import SwiftUI

struct ListFormNewCardView: View {
    @EnvironmentObject var dm: DM
    @EnvironmentObject var keyboardState: KeyboardState
    @FocusState private var isFocused: Bool
    
    @Binding var nameCard: String // TextField
    @Binding var selectedColorId: Int // color groupId
    
    var body: some View {
        
        List {
            HStack() {
                Text("Name")
                    .font(.custom(AppSize.fontRegular, size: AppSize.titleRegular))
                    .foregroundStyle(Color(AppSize.colorFont))
                
                TextField("Enter name", text: $nameCard )
                    .focused($isFocused)
                    .font(.custom(AppSize.fontSemiBold, size: AppSize.titleRegular))
                    .foregroundStyle(Color(AppSize.colorFont))
                    
                //.textFieldStyle(.roundedBorder)
                    .onChange(of: isFocused) { oldValue, newValue in
                        keyboardState.isFocused = newValue
                    }
                    .submitLabel(.done)
                    .onSubmit {
                        // скрыть клавиатуру или перейти к следующему полю
                        UIApplication.shared.endEditing()
                    }
            }
            
            HStack(alignment: .center) {
                Text("Color")
                    .font(.custom(AppSize.fontRegular, size: AppSize.titleRegular))
                    .foregroundStyle(Color(AppSize.colorFont))
                CustomColorPicker(selectedColorId: $selectedColorId)
            }
            
            if ( dm.parentCardIdOpened < 0 ) {
                Toggle("Will the card contain other cards ?", isOn: $dm.isCardContainGroup)
                    .font(.custom(AppSize.fontRegular, size: AppSize.titleRegular))
                    .foregroundStyle(.gray)
                    .animation(.snappy, value: dm.isCardContainGroup)
                    .padding(.top)
                    .disabled(dm.checkIsParent(id: dm.contextCardId) && dm.isStateEdiding)
            }
        }
        .cornerRadius(AppSize.cornerRadius)
    }
}

#Preview {
    
    let testSpeechManager = SpeechManager(lang: Settings().storedLanguage)
    let dm = DM(speechManager: testSpeechManager)
    var keyboardState = KeyboardState()
    ListFormNewCardView(
        nameCard: .constant("Animals"),
        selectedColorId: .constant(1))
    .environmentObject(dm)
    .environmentObject(keyboardState)
    
}

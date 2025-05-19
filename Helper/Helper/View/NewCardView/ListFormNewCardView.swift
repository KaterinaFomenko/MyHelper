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
                VStack(alignment: .leading) {
                    Text("Name")
                        .font(.headline)
                    
                    TextField("Enter name", text: $nameCard )
                        .focused($isFocused)
                        .textFieldStyle(.roundedBorder)
                        .onChange(of: isFocused) { oldValue, newValue in
                            keyboardState.isFocused = newValue
                        }
                }
            
                HStack(alignment: .center) {
                    Text("Color")
                        .font(.headline)
                    CustomColorPicker(selectedColorId: $selectedColorId)
                }
                
                
            //   if ( dm.parentCardIdOpened < 0 ) && keyboardState.keyboardHeight == 0 {
                if ( dm.parentCardIdOpened < 0 ) {
                    Toggle("Will the card contain other cards ?", isOn: $dm.isCardContainGroup)
                        .font(.custom("Helvetica Neue", size: 20))
                        .foregroundStyle(.gray)
                        .animation(.snappy, value: dm.isCardContainGroup)
                        .padding(.top)
                        .disabled(dm.checkIsParent(id: dm.contextCardId) && dm.isStateEdiding)
                }
            }
            .cornerRadius(15)
           
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

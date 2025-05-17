//
//  ListFormNewCardView.swift
//  Helper
//
//  Created by Катерина Фоменко on 17/05/2025.
//

import SwiftUI

struct ListFormNewCardView: View {
    @EnvironmentObject var dm: DM
    @ObservedObject private var keyboard = KeyboardResponder()
    
    @Binding var nameCard: String // TextField
    @Binding var selectedColorId: Int // color groupId
    @FocusState private var isFocused: Bool
    
    var body: some View {
        List {
            VStack(alignment: .leading) {
                Text("Name")
                    .font(.headline)
                
                TextField("Enter name", text: $nameCard )
                    .focused($isFocused)
                
            }
            
            if keyboard.currentHeight == 0 {
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
        }
    }
}

#Preview {
   
    let testSpeechManager = SpeechManager(lang: Settings().storedLanguage)
    let dm = DM(speechManager: testSpeechManager)
    ListFormNewCardView(
        nameCard: .constant("Animals"),
        selectedColorId: .constant(1))
        .environmentObject(dm)
}

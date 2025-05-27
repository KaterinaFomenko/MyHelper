//
//  SelectedCardsView.swift
//  Helper
//
//  Created by Катерина Фоменко on 17/02/2025.
//

import SwiftUI
// Top Line View of selected cards
struct SelectedCardsView: View {
    
    var columsTop: [GridItem] = [GridItem(.fixed(100))]
    @EnvironmentObject var dm: DM
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal) {
                LazyHGrid(rows: columsTop) {
                    ForEach(dm.selectedItemsArray.compactMap { $0 }, id: \.cardId) { item in
                        CardViewForSecectedCards(card: item)
                            .id(item)
                    }
                }
                .padding(.horizontal, 20)
            }
          
            .frame(height: 100)
            .onChange(of: dm.selectedItemsArray) { oldValue, newValue in
                print("On change")
                withAnimation {
                     
                    proxy.scrollTo(newValue.last, anchor: .bottomTrailing)
                  //  print("👀 Last element \(newValue.last)")
                }
            }
        }
//        .background(Color("LaunchScreenBG"))
//        .opacity(0.7)
    }
}

#Preview {
    var sp = SpeechManager(lang: "en")
    SelectedCardsView()
        .environmentObject(DM(speechManager: sp))
}

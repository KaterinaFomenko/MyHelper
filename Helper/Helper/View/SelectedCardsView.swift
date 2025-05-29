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
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    var isTabletLayout: Bool {
        horizontalSizeClass == .regular && verticalSizeClass == .regular
    }
    
    var body: some View {
      if isTabletLayout == true {
            Rectangle()
            // this Rectangle for more air
                .fill(.clear)
                .frame(height: 20)
        }
        
        ScrollViewReader { proxy in
            ScrollView(.horizontal) {
                LazyHGrid(rows: columsTop) {
                    ForEach(dm.selectedItemsArray.compactMap { $0 }, id: \.cardId) { item in
                        CardViewForSecectedCards(card: item)
                            .id(item)
                    }
                }
                .frame(height: 100)
                .padding(.horizontal, 20)
            }
            //.background(.yellow)
            .onChange(of: dm.selectedItemsArray) { oldValue, newValue in
                print("On change")
                withAnimation {
                     
                    proxy.scrollTo(newValue.last, anchor: .bottomTrailing)
                  //  print("👀 Last element \(newValue.last)")
                }
            }
        }
    }
}

#Preview {
    var sp = SpeechManager(lang: "en")
    SelectedCardsView()
        .environmentObject(DM(speechManager: sp))
}

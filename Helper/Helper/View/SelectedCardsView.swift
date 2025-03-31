//
//  SelectedCardsView.swift
//  Helper
//
//  Created by Катерина Фоменко on 17/02/2025.
//

import SwiftUI
// Горизонтальный LazyHGrid
struct SelectedCardsView: View {
    
    var columsTop: [GridItem] = [GridItem(.fixed(100))]
    @EnvironmentObject var dm: DM   // следим за изменениями
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal) {
                LazyHGrid(rows: columsTop) {
                    ForEach(dm.selectedItemsArray.compactMap { $0 }, id: \.cardId) { item in
                        CardViewForSecectedCards(card: item)
                            .id(item)
                    }
                }.padding()
            }
            .frame(height: 40)
            .padding()
            .onChange(of: dm.selectedItemsArray) { oldValue, newValue in
                print("On change")
                withAnimation {
                     
                    proxy.scrollTo(newValue.last, anchor: .bottomTrailing)
                    print("👀 Last element \(newValue.last)")
                    
                }
            }
        }
    }
}

#Preview {
   
    SelectedCardsView()
        .environmentObject(DM.shared) 
}

//struct SelectedCardsView_Previews: PreviewProvider {
//    static var previews: some View {
//        SelectedCardsView()
//            .environmentObject(DM.shared) // Передаём `DM`, чтобы видеть `selectedItemsArray`
//    }
//     
//    
//}

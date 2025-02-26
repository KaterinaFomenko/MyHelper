//
//  SelectedCardsView.swift
//  Helper
//
//  Created by Катерина Фоменко on 17/02/2025.
//

import SwiftUI
// Горизонтальный LazyHGrid
struct SelectedCardsView: View {
    
    @Binding var columsTop: [GridItem]
    @EnvironmentObject var dm: DM   // следим за изменениями
    
    var body: some View {
        
        LazyHGrid(rows: columsTop) {
            ForEach(dm.selectedItemsArray, id: \.cardId) { item in
                CardViewForSecectedCards(card: item)
            }
        }.padding()
    }
}

#Preview {
    @Previewable @State var columsTop = [GridItem(.flexible())]
    SelectedCardsView(columsTop: $columsTop)
        .environmentObject(DM.shared) // Передаём `DM`, чтобы видеть `selectedItemsArray`
}

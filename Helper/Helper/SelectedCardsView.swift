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
    @EnvironmentObject var dm: DM   // Теперь следим за изменениями
    
    var body: some View {
        
        LazyHGrid(rows: columsTop) {
            ForEach(dm.selectedItemsArray) { item in
                CardView(card: item)
            }
        }.padding()
    }
}

#Preview {
    @Previewable @State var columsTop = [GridItem(.flexible())]
    SelectedCardsView(columsTop: $columsTop)
        .environmentObject(DM.shared) // Передаём `DM`, чтобы видеть `selectedItemsArray`
}

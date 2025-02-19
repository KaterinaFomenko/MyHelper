//
//  SelectedItemsView.swift
//  Helper
//
//  Created by Катерина Фоменко on 17/02/2025.
//

import SwiftUI
// Горизонтальный LazyHGrid
struct SelectedItemsView: View {
    
    @Binding var columsTop: [GridItem]
    @EnvironmentObject var dM: DM   // Теперь следим за изменениями
    
    var body: some View {
        
        LazyHGrid(rows: columsTop) {
            // + GETselectedItemsArray
            ForEach(dM.selectedItemsArray) { item in
                CardView(card: item)
            }
        }.padding()
    }
}

#Preview {
    @Previewable @State var columsTop = [GridItem(.flexible())]
    SelectedItemsView(columsTop: $columsTop)
        .environmentObject(DM.shared) // Передаём `DM`, чтобы видеть `selectedItemsArray`
}

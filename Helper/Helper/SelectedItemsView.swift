//
//  SelectedItemsView.swift
//  Helper
//
//  Created by Катерина Фоменко on 17/02/2025.
//

import SwiftUI

struct SelectedItemsView: View {
    
    @Binding var columsMain: [GridItem]
    var body: some View {
        
        LazyHGrid(rows: columsMain) {
            // + GETselectedItemsArray
            ForEach(DM.selectedItemsArray) { item in
                CardView(card: item)
               
            }
        }.padding()
    }
}

#Preview {
    @Previewable @State var colums = [GridItem(.flexible())]
    return CardGridView(colums: $colums) // передаём $ для Binding
}

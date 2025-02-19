//
//  CardGridView.swift
//  Helper
//
//  Created by Катерина Фоменко on 13/02/2025.
//

import SwiftUI
// Вертикальный Grid
struct CardGridView: View {
    
    @Binding var colums: [GridItem]
    @EnvironmentObject var dataManager: DM
    
    var body: some View {
        
        LazyVGrid(columns: colums, pinnedViews: .sectionHeaders) {
            Section {
                ForEach(DM.shared.getCards(section: 0)) { item in
                    CardView(card: item)
                        .onTapGesture {
                            DM.shared.addItemToSelected(item: item)
                            
                            print("!!!selectedItemsArray: \(DM.shared.selectedItemsArray)")
                        }
                }
            } header: {
                Text("Favorites")
                    .font(.largeTitle.bold())
                    .padding(.bottom, 5)
            }
            
            Section {
                ForEach(DM.shared.getCards(section: 1)) { item in
                    CardView(card: item)
                }
            } header: {
                Text("General actions")
                    .font(.largeTitle.bold())
                    .padding(.bottom, 5)
            }
        }
    }
}

#Preview {
    @Previewable @State var colums = [GridItem(.flexible())]
    return CardGridView(colums: $colums) // передаём $ для Binding
}

//
//  CardGridView.swift
//  Helper
//
//  Created by Катерина Фоменко on 13/02/2025.
//

import SwiftUI

struct CardGridView: View {
    
    @Binding var colums: [GridItem]
   
    var body: some View {
       
            LazyVGrid(columns: colums, pinnedViews: .sectionHeaders) {
                Section {
                    ForEach(DM.getCards(section: 0)) { item in
                        CardView(card: item)
                        //17.02
                            .onTapGesture {
                             // print("!!!Selected item in section: \(item)")
                                
                                DM.addItemToSelected(item: item)
                                
                                print("!!!selectedItemsArray: \(DM.selectedItemsArray)")
                            }
                         
                    }
                } header: {
                    Text("Favorites")
                        .font(.largeTitle.bold())
                        .padding(.bottom, 5)
                }
                
                Section {
                    ForEach(DM.getCards(section: 1)) { item in
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

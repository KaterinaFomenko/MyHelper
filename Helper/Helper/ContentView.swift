//
//  ContentView.swift
//  Helper
//
//  Created by Катерина Фоменко on 09/02/2025.
//
import SwiftUI

struct ContentView: View {
   // @State var columsTop2 = [GridItem(.adaptive(minimum: 50, maximum: 50))]
    
//   95 - ширина одной ячейки
    @State var columsMain = [GridItem(.adaptive(minimum: 100), spacing: 0)]
   
    @State var columsTop = [GridItem(.fixed(100))]
   
    @StateObject private var model = DM.shared // Управляем состоянием DM
        
    var body: some View {
        
                VStack(spacing: 0)  {
                   
                    // Горизонтальный LazyHGrid
                    ScrollView(.horizontal) {
                        SelectedItemsView(columsTop: $columsTop)
                            .environmentObject(model)
                    }
                    .frame(height: 120)
                    .padding()
                   
                    // Серый разделитель
                    Rectangle()
                        .fill(Color.gray)
                        .frame(height: 30)
                    
                    // Вертикальный Grid
                    ScrollView {
                        CardGridView(colums: $columsMain)
                            .environmentObject(model)
                    }
                }
            }
        }
    


#Preview {
    
    ContentView()
}

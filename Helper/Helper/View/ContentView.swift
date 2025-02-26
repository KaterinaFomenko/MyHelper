//
//  ContentView.swift
//  Helper
//
//  Created by Катерина Фоменко on 09/02/2025.
//
import SwiftUI

struct ContentView: View {
    
    // Управляем состоянием DM
    @ObservedObject private var dm = DM.shared
    
    //   100 - ширина одной ячейки
    @State var columsMain = [GridItem(.adaptive(minimum: 100), spacing: 0)]
    @State var columsTop = [GridItem(.fixed(100))]
   
    
    var body: some View {
        
        VStack(spacing: 0)  {
            
            // Горизонтальный Scroll
            ScrollView(.horizontal) {
                SelectedCardsView(columsTop: $columsTop)
                    .environmentObject(dm)
            }
            .frame(height: 120)
            .padding()
            
            // Серый разделитель
            ZStack() {
                Rectangle()
                    .fill(Color.blue.opacity(0.1))
                    .frame(height: 80)
                HStack {
                    Spacer()
                    SettingsView()
                        .environmentObject(dm)
                }
            }
            
            // Вертикальный MainScroll
            ScrollView {
                VStack {
                    MainCardsView(colums: $columsMain)
                        .environmentObject(dm)

                }
            }
        }
    }
}



#Preview {
    
    ContentView()
}

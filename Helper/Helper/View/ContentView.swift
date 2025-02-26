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

    var body: some View {
        
        VStack(spacing: 0)  {
            // Горизонтальный Scroll
                    SelectedCardsView()
                        .environmentObject(dm)
                }

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
                    MainCardsView()
                        .environmentObject(dm)
                }
            }
        }
    }




#Preview {
    
    ContentView()
}

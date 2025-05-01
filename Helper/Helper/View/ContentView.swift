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
            Rectangle()
                .fill(Color.blue.opacity(0.1))
                .frame(height: 20)
                .padding(.bottom, 10)
            
            // Горизонтальный Scroll
            SelectedCardsView()
                .padding(10)
                .environmentObject(dm)
        }
        
        // Голубой разделитель
        ZStack() {
            Rectangle()
                .fill(Color.blue.opacity(0.1))
                .frame(height: 60)
            HStack() {
                Spacer()
                
                SelectedParentCardView()
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

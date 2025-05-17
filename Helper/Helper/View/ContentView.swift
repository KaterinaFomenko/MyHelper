//
//  ContentView.swift
//  Helper
//
//  Created by Катерина Фоменко on 09/02/2025.
//
import SwiftUI

struct ContentView: View {
    
    var body: some View {
        VStack {
            VStack(spacing: 0)  {
                Rectangle()
                    .fill(Color.blue.opacity(0.1))
                    .frame(height: 20)
                    .padding(.bottom, 10)
                
                SelectedCardsView()
                    .padding(10)
                    .padding(.bottom, 10)
                
                SelectedParentCardView()
            }
            
            ScrollView {
                MainCardsView()
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(DM(speechManager: SpeechManager(lang: "en")))
        .environmentObject(Settings())
}

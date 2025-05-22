//
//  ContentView.swift
//  Helper
//
//  Created by Катерина Фоменко on 09/02/2025.
//
import SwiftUI

struct ContentView: View {
    
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
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
                    MainCardsView(path: $path)
                }
            }
            
            .navigationDestination(for: CardModel.self) { card in
                NewCardView(card: card)
            }
        }
    }
}
#Preview {
    ContentView()
        .environmentObject(DM(speechManager: SpeechManager(lang: "en")))
        .environmentObject(Settings())
}

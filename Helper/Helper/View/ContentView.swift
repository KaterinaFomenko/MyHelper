//
//  ContentView.swift
//  Helper
//
//  Created by Катерина Фоменко on 09/02/2025.
//
import SwiftUI

class NavigationCoordinator: ObservableObject {
    @Published var path = NavigationPath()
}

struct ContentView: View {
  //  @StateObject var coordinator = NavigationCoordinator()
    @EnvironmentObject var coordinator: NavigationCoordinator
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
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

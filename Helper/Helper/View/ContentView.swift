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
 
    @EnvironmentObject var coordinator: NavigationCoordinator
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            VStack {
                VStack(spacing: 0)  {
                    Rectangle()
                        .fill(Color("BlueLight"))
                        .opacity(0.7)
                        .frame(height: 20)
                      
                    SelectedCardsView()
                        .background(Color("LaunchScreenBG"))
                       // .opacity(0.7)
                    
                    SelectedParentCardView()
                }
                
                ScrollView {
                    MainCardsView()
                }
            }
            .background(Color(hex: "F8F8F8"))
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
        .environmentObject(NavigationCoordinator())
}

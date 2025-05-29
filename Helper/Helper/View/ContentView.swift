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
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    var isTabletLayout: Bool {
        horizontalSizeClass == .regular && verticalSizeClass == .regular
    }
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            ZStack(alignment: .top) {
                
                VStack(spacing: 0)  {
                    SelectedCardsView()
                    SelectedParentCardView()
                }
                
                .background(AppColors.linearGradient())
                
                ViewForMainCards()
                    .padding(.top, isTabletLayout ? 200 : 170)
                    .ignoresSafeArea(edges: .bottom)
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
        .environmentObject(NavigationCoordinator())
}

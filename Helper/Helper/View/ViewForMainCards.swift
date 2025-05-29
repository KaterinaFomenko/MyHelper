//
//  ViewForMainCards.swift
//  Helper
//
//  Created by Катерина Фоменко on 29/05/2025.
//

import SwiftUI

struct ViewForMainCards: View {
    var body: some View {
        VStack {
            MainCardsView()
             //   .padding(.top, 20)
        }
       
        .background(Color(hex: "F1F1F1"))
        .clipShape(RoundedCorner(radius: 30, corners: [.topLeft, .topRight]))
        .shadow(color: .gray.opacity(0.7), radius: 5, x: 0, y: -5)
      
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    ViewForMainCards()
        .environmentObject(DM(speechManager: SpeechManager(lang: Settings().storedLanguage)))
}

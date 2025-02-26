//
//  CardView.swift
//  Helper
//
//  Created by Катерина Фоменко on 13/02/2025.
//

import SwiftUI

struct CardView: View {
    
    let card: CardModel
    
    var body: some View {
        VStack(spacing: 1.0) {
            Text(card.title)
                .font(.custom("Helvetica Neue", size: 20))
                .multilineTextAlignment(.center)
            
            Image(card.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 60)
                .padding(.bottom, 5)
        }
        .frame(width: 90)
        .background(RoundedRectangle(cornerRadius: 10)
            .fill(Color(hex: DM.shared.getColor(groupId: card.groupId)))
            .opacity(0.5)
            .shadow(color: .gray, radius: 2, x: 3, y: 3)
        )
    }
}

#Preview {
    var card = CardModel(cardId: 1, title: "I", groupId: 1, imageName: "I2")
    CardView(card: card)
    
}

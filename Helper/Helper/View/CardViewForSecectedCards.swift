//
//  CardViewForSecectedCards.swift
//  Helper
//
//  Created by Катерина Фоменко on 26/02/2025.
//
//
//  CardView.swift
//  Helper
//
//  Created by Катерина Фоменко on 13/02/2025.
//

import SwiftUI

struct CardViewForSecectedCards: View {
    
    let card: CardModel
    
    var body: some View {
        VStack(spacing: 1.0) {
          //  Text(card.title)
            Text(LocalizedStringKey(card.titleKey))
                .font(.custom("Helvetica Neue", size: 25))
                .multilineTextAlignment(.center)
            
            CardImageView(imageName: card.imageName)
        }
        
    }
}

#Preview {
    var card = CardModel(cardId: 2, titleKey: "Hello World", groupId: 2, imageName: "I2", priority: 1)
    CardViewForSecectedCards(card: card)
    
}


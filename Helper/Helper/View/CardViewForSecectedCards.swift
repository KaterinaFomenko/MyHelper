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
        VStack(spacing: 1) {
            Text(LocalizedStringKey(card.titleKey))
                .font(.custom(AppSize.fontRegular, size: AppSize.titleSemiBold))
                .foregroundStyle(Color(AppSize.colorFont))
                .multilineTextAlignment(.center)
            
            CardImageView(imageName: card.imageName)
                .foregroundStyle(.white)
        }
    }
}

#Preview {
    var card = CardModel(
        cardId: 2,
        titleKey: "Hello World",
        groupId: 2,
        imageName: "I",
        priority: 1
    )
    CardViewForSecectedCards(card: card)
    
}


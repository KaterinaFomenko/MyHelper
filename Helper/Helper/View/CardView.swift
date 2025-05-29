//
//  CardView.swift
//  Helper
//
//  Created by Катерина Фоменко on 13/02/2025.
//

import SwiftUI

struct CardView: View {
    @EnvironmentObject var dm: DM
    let card: CardModel
    var hasChildren: Bool // will card contain childCards?
    
    var body: some View {
        VStack(spacing: 1.0) {
            Text(LocalizedStringKey(card.titleKey))
                .padding(.horizontal, 2)
                .foregroundStyle(Color(AppSize.colorFont))
                .font(.custom(AppSize.fontSemiBold, size: AppSize.titleRegular))
                .multilineTextAlignment(.center)
                
            CardImageView(imageName: card.imageName)
            
                HStack {
                    Spacer()
                    ChildCardImage(hasChildren: hasChildren)
            }
        }
        .frame(width: 115, height: 100)
        .background(RoundedRectangle(cornerRadius: 10)
            .fill(AppColors.getColor(groupId: card.groupId))
            .opacity(0.75)
            .shadow(color: .gray.opacity(1), radius: 5, x: 0, y: -3)
        )
    }
}

#Preview {
    var card1 = CardModel(cardId: 1, titleKey: "Irrrrrrrrrrrrhhhh", groupId: 1, imageName: "puzzle")
   
    VStack {
        CardView(card: card1, hasChildren: true)
    }
    .environmentObject(DM(speechManager: SpeechManager(lang: Settings().storedLanguage)))
}


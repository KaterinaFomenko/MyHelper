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
    var hasChildren: Bool  // will card contain childCards?
    
    var body: some View {
        VStack(spacing: 1.0) {
            Text(LocalizedStringKey(card.titleKey))
                .font(.custom("Helvetica Neue", size: 20))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 2)
            
            CardImageView(imageName: card.imageName)
            
                HStack {
                    Spacer()
                    
                    Image(systemName: "circle.fill")
                        .resizable()
                        .frame(width: 5, height: 5)
                        .foregroundColor(hasChildren ? .blue : .clear)
                        .padding(.horizontal, 5)
                        .padding(.bottom, 5)
                        .shadow(radius: 10)
                        .opacity(0.5)
            }
        }
        .frame(width: 120, height: 100)
        .background(RoundedRectangle(cornerRadius: 10)
            .fill(AppColors.getColor(groupId: card.groupId))
          //  .fill(AppColors.color(for: Int(card.cardId)))
            .opacity(0.45)
            .shadow(color: .gray, radius: 2, x: 3, y: 3)
        )
    }
}

#Preview {
    var card1 = CardModel(cardId: 1, titleKey: "I", groupId: 1, imageName: "puzzle")
    var card2 = CardModel(cardId: 1, titleKey: "Forest animals", groupId: 2, imageName: "forest animals")
   
    VStack {
        CardView(card: card1, hasChildren: true)
        CardView(card: card2, hasChildren: false)
           
    }
    .environmentObject(DM(speechManager: SpeechManager(settings: Settings())))
}

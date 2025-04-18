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
            Text(card.titleKey.loc)
                .font(.custom("Helvetica Neue", size: 20))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 2)
            
            CardImageView(imageName: card.imageName, fallImageName: "scribble")
            
// if card has child cards show ellipsis
            if hasChildren {
                HStack {
                    Spacer()
                    
                    Image(systemName: "circle.fill")
                        .resizable()
                        .frame(width: 5, height: 5)
                        .foregroundColor(.blue)
                        .padding(.horizontal, 5)
                        .padding(.bottom, 5)
                        .shadow(radius: 10)
                }
            }
        }
        .frame(width: 100, height: 100)
        .background(RoundedRectangle(cornerRadius: 10)
            .fill(AppColors.getColor(groupId: card.groupId))
            .opacity(0.5)
            .shadow(color: .gray, radius: 2, x: 3, y: 3)
        )
    }
}

//#Preview {
//    var card1 = CardModel(cardId: 1, title: "I", groupId: 1, imageName: "puzzle")
//    var card2 = CardModel(cardId: 1, title: "I", groupId: 1, imageName: "Andrii")
//   
//    VStack {
//        CardView(card: card1, hasChildren: true)
//            
//        
//        CardView(card: card2, hasChildren: false)
//           
//    }
//    .environmentObject(DM.shared)
//}

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
    
    var body: some View {
        VStack(spacing: 1.0) {
            Text(card.title)
                .font(.custom("Helvetica Neue", size: 20))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 2)
            
            // loadFromJSON image from local directory
            if let image = ImageService.shared.loadImageFromDiskWith(fileName: card.imageName) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 65, height: 65)
                    .cornerRadius(5)
            } else {
            // loadFromJSON from asset
                Image(card.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 65, height: 65)
                    .cornerRadius(5)
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

#Preview {
    
    var card = CardModel(cardId: 1, title: "I", groupId: 1, imageName: "Andrii")
    CardView(card: card)
}

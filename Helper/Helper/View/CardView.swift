//
//  CardView.swift
//  Helper
//
//  Created by Катерина Фоменко on 13/02/2025.
//

import SwiftUI

struct CardView: View {
    
    let card: CardModel
  //  @ObservedObject var userSaving: UserSaving
    @EnvironmentObject var dm: DM
    
    var body: some View {
        VStack(spacing: 1.0) {
            
           // if !userSaving.parentCardArray.isEmpty {
            
           //     Text(userSaving.parentCardArray.first?.title ?? card.title)
            if let savedCard = dm.parentCardsArray.first(where: { $0.cardId == card.cardId }) {
                Text(savedCard.title)
                    .font(.custom("Helvetica Neue", size: 20))
                    .multilineTextAlignment(.center)
            } else {
                Text(card.title)
                    .font(.custom("Helvetica Neue", size: 20))
                    .multilineTextAlignment(.center)
            }
            
            //try loadFromJSON image from local directory
            if let image = ImageService.shared.loadImageFromDiskWith(fileName: card.imageName) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .padding(.bottom, 5)
            } else { // loadFromJSON from asset
                Image(card.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .padding(.bottom, 5)
            }
        }
        
        .frame(width: 100, height: 100 )
        .background(RoundedRectangle(cornerRadius: 10)
            .fill(AppColors.getColor(groupId: card.groupId))
            .opacity(0.5)
            .shadow(color: .gray, radius: 2, x: 3, y: 3)
        )
    }
}

#Preview {
    var card = CardModel(cardId: 1, title: "I", groupId: 1, imageName: "I2")
    let userSaving = UserSaving()
    CardView(card: card)
    
}

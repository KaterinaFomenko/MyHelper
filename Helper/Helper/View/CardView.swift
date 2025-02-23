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
                .font(.title)
                .fontWeight(.semibold)
                
                Image(card.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80)
            }
            .frame(width: 90)
            .background(RoundedRectangle(cornerRadius: 10)
                .fill(.white))
    }
}

//#Preview {
//    CardView(
//        card: CardModel(childCards: ChildCards(
//            title: "Play",
//            color: "255,0,0",
//            groupId: 1,
//            image: "cubesV_xBG",
//            cardId: 1
//        )
//    )
//}

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
                
                Image(card.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80)
            }
            .frame(width: 90)
            .background(RoundedRectangle(cornerRadius: 10)
            .fill(Color.blue.opacity(0.3)))
    }
}

#Preview {
    CardView(card: CardModel(title: "Play", image: "cubesV_xBG"))
}

//
//  ChildCardImage.swift
//  Helper
//
//  Created by Катерина Фоменко on 15/05/2025.
//

import SwiftUI

struct ChildCardImage: View {
    let hasChildren: Bool
    
    var body: some View {
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

#Preview {
    ChildCardImage(hasChildren: true)
}

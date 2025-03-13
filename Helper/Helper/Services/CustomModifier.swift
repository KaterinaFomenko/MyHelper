//
//  CustomModifier.swift
//  Helper
//
//  Created by Катерина Фоменко on 22/02/2025.
//

import SwiftUI

// Модификатор для стилизации фона

struct CustomButtonModifier: ViewModifier {
    let isPressed: Bool
    func body(content: Content) -> some View {
        content
            .padding()
            .font(.headline)
            .foregroundStyle(.white)
            .fontWeight(.bold)
            .frame(width: 150)
            .background(.blue)
            .clipShape(RoundedRectangle(cornerRadius: 50))
            .shadow(radius: 5)
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.easeInOut, value: isPressed)
    }
}

//struct ImageToStringModifier: ViewModifier {
//    let image: UIImage
//    
//    func body(content: Content) -> some View {
//        let image = image.to
//        content
//    }
//}

#Preview {
    
}

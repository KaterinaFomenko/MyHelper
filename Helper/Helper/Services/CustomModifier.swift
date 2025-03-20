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
    let backgroundColor: Color
    let textColor: Color
    
    func body(content: Content) -> some View {
        content
            .padding()
            .font(.headline)
            .fontWeight(.bold)
            .frame(width: 150)
            .background(backgroundColor)
            .foregroundStyle(textColor)
            .clipShape(RoundedRectangle(cornerRadius: 50))
            .shadow(radius: 5)
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.easeInOut, value: isPressed)
    }
}

#Preview {
    VStack {
        Text("Add image")
            .modifier(CustomButtonModifier(isPressed: false, backgroundColor: .gray, textColor: .black))
        
        Text("Add image")
            .modifier(CustomButtonModifier(isPressed: true, backgroundColor: .blue, textColor: .white))
    }
}

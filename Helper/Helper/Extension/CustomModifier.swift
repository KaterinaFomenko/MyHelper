//
//  CustomModifier.swift
//  Helper
//
//  Created by Катерина Фоменко on 22/02/2025.
//

import SwiftUI

struct CustomTextModifier: ViewModifier {
    var font: Font
    var color: Color
    
    func body(content: Content) -> some View {
        content
            .font(font)
            .foregroundColor(color)
    }
}

extension View {
    func myCustomText(font: Font, color: Color = .cyan) -> some View {
        modifier(CustomTextModifier(font: font, color: color))
    }
}

struct CustomContentView: View {
    var body: some View {
        Text("Hello, World!")
            .myCustomText(font: .largeTitle, color: .green)
    }
}

#Preview {
    CustomContentView()
}

//
//  CustomColorPicker.swift
//  Helper
//
//  Created by Катерина Фоменко on 04/03/2025.
//

import SwiftUI

struct CustomColorPicker: View {
    
    let arrayColor: [Color] = [.red, .green, .blue, .yellow, .brown, .purple, .orange, .pink, .gray, .white, .cyan]
    
    @Binding var selectedColor: Color
    
    var body: some View {
        VStack(alignment: .leading) {
            
            ScrollView(.horizontal, showsIndicators: false) {
                
                HStack(spacing: 10) {
                    ForEach(arrayColor, id: \.self) { color in
                        
                        ColorPickerItem(color: color, isSelected: color == selectedColor)
                        
                            .onTapGesture {
                                print("color: \(color)")
                                withAnimation {
                                    selectedColor = color
                                }
                            }
                    }
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .clipShape(.rect(cornerRadius: 10))
        }
    }
}

#Preview {
    @State var isSelected: Bool = false
    CustomColorPicker(selectedColor: .constant(.blue))
}

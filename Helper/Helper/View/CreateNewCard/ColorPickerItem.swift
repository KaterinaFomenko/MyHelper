//
//  ColorPickerItem.swift
//  Helper
//
//  Created by Катерина Фоменко on 04/03/2025.
//

import SwiftUI

struct ColorPickerItem: View {
    let color: Color
    let isSelected: Bool
    let selectedDiameter: CGFloat = 30
    let notSelectedDiameter: CGFloat = 20

    var body: some View {
       
            Circle()
            .fill(color)
            .frame(width: isSelected ? selectedDiameter : notSelectedDiameter)
    }
}

#Preview {
    VStack {
        ColorPickerItem(color: .blue, isSelected: false )
        ColorPickerItem(color: .red, isSelected: true )
    }
   
}

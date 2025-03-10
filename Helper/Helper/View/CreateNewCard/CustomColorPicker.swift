//
//  CustomColorPicker.swift
//  Helper
//
//  Created by Катерина Фоменко on 04/03/2025.
//

import SwiftUI

    

struct CustomColorPicker: View {
    
    @Binding var selectedColorId: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            
            ScrollView(.horizontal, showsIndicators: false) {
                
                HStack(spacing: 10) {
                    ForEach(AppColors.arrayColorIds, id: \.self) { colorId in
                        
                        ColorPickerItem(
                            color: AppColors.getColor(groupId: colorId),
                            isSelected: colorId == selectedColorId
                        )
                            .onTapGesture {
                                print("color: \(colorId)")
                                withAnimation {
                                    selectedColorId = colorId
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

// MARK: - Preview
struct CustomColorPicker_Previews: PreviewProvider {
    static var previews: some View {
        CustomColorPicker(selectedColorId: .constant(1))
    }
}

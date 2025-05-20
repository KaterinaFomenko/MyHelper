//
//  SaveButtonView.swift
//  Helper
//
//  Created by Катерина Фоменко on 17/05/2025.
//

import SwiftUI

struct SaveButtonView: View {
    @Binding var isPressed: Bool
    var isDisabled: Bool
    var action: () -> Void
    
    var body: some View {
        
        Button(action: action) {
            Text("Save")
                .frame(minWidth: 80)
                .modifier(
                    CustomButtonModifier(
                        isPressed: isPressed,
                        backgroundColor: isDisabled ? .grayLight1 : .blue,
                        textColor: isDisabled ? .black : .white
                    )
                )
        }
        .disabled(isPressed)
    }
}

#Preview("Pressed") {
    SaveButtonView(
        isPressed: .constant(true),
                   isDisabled: false,
                   action: {}
    )
}

#Preview("Not pressed") {
    SaveButtonView(
        isPressed: .constant(false),
                   isDisabled: true,
                   action: {}
    )
}

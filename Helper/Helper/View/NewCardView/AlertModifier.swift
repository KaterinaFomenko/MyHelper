//
//  AlertModifier.swift
//  Helper
//
//  Created by Катерина Фоменко on 17/05/2025.
//

import SwiftUI

struct AlertModifier: ViewModifier {
    @Binding var showAlert: Bool
    var alertMessage = ""
    
    func body(content: Content) -> some View {
        content
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Warning"),
                      message: Text(alertMessage),
                      dismissButton: .default(Text("OK")))
            }
    }
}



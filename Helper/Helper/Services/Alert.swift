//
//  Alert.swift
//  Helper
//
//  Created by Катерина Фоменко on 17/03/2025.
//

import Foundation

import SwiftUI

struct CustomAlert: View {
    var title: String = "Warning"
    var message: String
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
                .padding()
            
            Text(message)
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .padding()
            
            Button("OK~K") {
                isPresented = false
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 10)
        .frame(maxWidth: 300)
    }
}

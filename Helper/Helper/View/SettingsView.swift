//
//  SettingsView.swift
//  Helper
//
//  Created by Катерина Фоменко on 19/02/2025.
//

import SwiftUI
// Голубой разделитель
struct SettingsView: View {
    @State private var isPressed = false
    // @State private var textWay: String = "H"
    @EnvironmentObject var dm: DM
    
    
    var body: some View {
        HStack(alignment: .center) {
            
            Label("", systemImage: "house.circle.fill")
                .font(.system(size: 45))
                .foregroundStyle(.blue)
            
            Spacer()
            
            Button() {
                dm.removeLastItem()
            } label: {
                Image(systemName: "delete.left.fill")
                    .font(.system(size: 25))
                    .padding(10)
                    .background(Color.blue)
                    .foregroundStyle(.white)
                    .clipShape(Circle())
                    .scaleEffect(isPressed ? 0.9 : 1.0)
            }
            .padding(.trailing, 10)
            .frame(width: 80, height: 100, alignment: .trailing) // для увеличения площади нажатия
            //.background(Color(.gray))
        }    }
}
#Preview {
    SettingsView()
}

//
//  SettingsView.swift
//  Helper
//
//  Created by Катерина Фоменко on 19/02/2025.
//

import SwiftUI

struct SettingsView: View {
    @State private var isPressed = false
    @EnvironmentObject var dm: DM
    
    
    var body: some View {
        HStack(alignment: .center) {

            
            Button {
                dm.removeLastItem()
            } label: {
                Image(systemName: "delete.left.fill")
                    .font(.system(size: 20))
                    .padding()
                    .background(Color.blue)
                    .foregroundStyle(.white)
                    .clipShape(Circle())
                    .scaleEffect(isPressed ? 0.9 : 1.0)
            } .frame(width: 100, height: 100)
        }
    }
}
#Preview {
    SettingsView()
}

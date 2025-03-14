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
    
    @EnvironmentObject var dm: DM
    
    var body: some View {
        HStack(alignment: .center) {
            
            Image("home5")
                .resizable()
                .scaledToFit()
                .frame(width: 46, height: 46)
                .scaleEffect(1)
                .clipShape(Circle())
                .background(Circle().fill(Color.white))
                .foregroundStyle(.blue)
                .padding(5)
                
        
                .onTapGesture {
                    dm.titleWay = ""
                }
            
            ScrollViewReader { proxy in
                ScrollView(.horizontal) {
                    Text(dm.titleWay)
                        .font(.system(size: 25))
                        .id(dm.titleWay)
                }.onChange(of: dm.titleWay) { oldValue, newValue in
                    withAnimation {
                        proxy.scrollTo(newValue, anchor: .trailing)
                    }
                }
            }
            
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
           // .background(Color(.gray))
        }    }
}

#Preview {
    
    SettingsView()
        .environmentObject(DM.shared)
}

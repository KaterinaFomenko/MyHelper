//
//  SettingsView.swift
//  Helper
//
//  Created by Катерина Фоменко on 19/02/2025.
//

import SwiftUI
// Голубой разделитель
struct SelectedParentCardView: View {
   // @State private var isPressed = false
    @State var isShowAdditionalSettingsView: Bool = false
    @EnvironmentObject var dm: DM
    @EnvironmentObject var settings: Settings // Добавляем EnvironmentObject для Settings
    
    
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
                    // dm.titleWay = ""
                    isShowAdditionalSettingsView.toggle()
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
                  //  .scaleEffect(isPressed ? 0.9 : 1.0)
            }
            .padding(.trailing, 10)
            .frame(width: 80, height: 60, alignment: .trailing) // для увеличения площади нажатия
            // .background(Color(.gray))
            
            
        }
        .sheet(isPresented: $isShowAdditionalSettingsView) {
            AdditionalSettingsView(isShowAdditionalSettingsView: $isShowAdditionalSettingsView)
                .environmentObject(settings)
        }
    }
        

}

#Preview {
    
    SelectedParentCardView()
        .environmentObject(DM.shared)
        .environmentObject(Settings())
}

//
//  SettingsView.swift
//  Helper
//
//  Created by Катерина Фоменко on 19/02/2025.
//

import SwiftUI
// Голубой разделитель
struct SelectedParentCardView: View {
    
    @State private var isShowLanguagePickerView: Bool = false
    @StateObject private var settings = Settings()
    @EnvironmentObject var dm: DM
    
    var body: some View {
        ZStack() {
            Rectangle()
                .fill(Color.blue.opacity(0.1))
                .frame(height: 60)
    
                HStack(alignment: .center) {
                    Image(systemName: "gearshape.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .foregroundStyle(.blue)
                        .padding(10)
                        .onTapGesture {
                            isShowLanguagePickerView.toggle()
                        }
                    let a = "\u{203A} "
                    let b = dm.titleWay
                   
                    Text(b.isEmpty ? "" : a).font(.system(size: 25)) + Text(dm.titleWay.lkey)
                        .font(.system(size: 25))
                     
                    Spacer()
                    
                    Button() {
                        dm.removeLastItem()
                    } label: {
                        Image(systemName: "delete.left.fill")
                            .font(.system(size: 20))
                            .padding(10)
                            .background(Color.blue)
                            .foregroundStyle(.white)
                            .clipShape(Circle())
                    }
                    .padding(.trailing, 10)
                    .frame(width: 80, height: 60, alignment: .trailing) // для увеличения площади нажатия
                }
                .sheet(isPresented: $isShowLanguagePickerView) {
                    SettingsView(settings: settings)
                }
            }
        }
    }

#Preview {
    SelectedParentCardView()
}

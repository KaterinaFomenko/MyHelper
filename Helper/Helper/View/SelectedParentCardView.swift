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
    @EnvironmentObject var speechManager: SpeechManager
    @EnvironmentObject var dm: DM
    @EnvironmentObject var settings: Settings
    
    var body: some View {
        VStack {
            ZStack() {
                HStack(alignment: .center) {
                    Image(systemName: "gearshape.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .symbolRenderingMode(.palette)
                        .foregroundStyle( .white, Color(hex: "7794A2"))
                        .padding(10)
                        .onTapGesture {
                            isShowLanguagePickerView.toggle()
                        }
                    let a = "\u{203A} "
                    let b = dm.titleWay
                    
                    Text(b.isEmpty ? "" : a)
                        .font(.system(size: 25)) + Text(dm.titleWay.lkey)
                        .font(.custom(AppSize.fontRegular, size: AppSize.titleRegular))
                    
                    Spacer()
                    
                    Button() {
                        dm.removeLastItem()
                    } label: {
                        Image(systemName: "delete.left.fill")
                            .font(.system(size: 20))
                            .padding(10)
                            .background(Color(hex: "7794A2"))
                            .foregroundStyle(.white)
                            .clipShape(Circle())
                    }
                    .padding(.trailing, 10)
                }
                .sheet(isPresented: $isShowLanguagePickerView) {
                    SettingsView(settings: settings)
                }
            }
            Rectangle()
                .fill(.clear)
                .frame(height: 60)
            
        }
        
        
    }
}

#Preview {
    SelectedParentCardView()
        .background(.yellow)
        .environmentObject(DM(speechManager: SpeechManager(lang: "en")))
}

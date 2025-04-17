//
//  LibraryIconsScreen.swift
//  Helper
//
//  Created by Катерина Фоменко on 05/03/2025.
//

import SwiftUI

struct LibraryIconsScreen: View {
    @Binding var isShowingLibraryIconsScreen: Bool
    @Binding var selectedIcon: String
    
    let icons = ["star.fill", "heart.fill", "cloud.fill", "moon.fill", "sun.max.fill"]
    
        var body: some View {
            VStack {
                
                Text("Select icon")
                    .font(.largeTitle)
                    .padding()

                
                HStack {
                    ForEach(icons, id: \.self) { icon in
                        Image(systemName: icon)
                            .onTapGesture {
                                print("Selected icon: \(icon)")
                                selectIcon(icon)
                            }
                            .font(.system(size: 50))
                    }
                }

                Button("Close") {
                    isShowingLibraryIconsScreen = false
                }
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
            .edgesIgnoringSafeArea(.all) // Занимаем весь экран
        }

        private func selectIcon(_ iconName: String) {
            print("Выбрана иконка: \(iconName)")
            selectedIcon = iconName
        }
    }

#Preview {
    LibraryIconsScreen(isShowingLibraryIconsScreen: .constant(true), selectedIcon: .constant("star.fill"))
}

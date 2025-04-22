//
//  IconLibraryView.swift
//  Helper
//
//  Created by Катерина Фоменко on 22/04/2025.
//

import SwiftUI

struct IconLibraryView: View {
    @EnvironmentObject var dm: DM
    @Binding var isShowIconGalary: Bool
    @Binding var selectedIconLibrary: String
    
    let columns = [GridItem(.adaptive(minimum: 100), spacing: 10)]
    
    var body: some View {

        let arrayImages = getAllImages(array: dm.parentCardsArray)
   
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                
                ForEach(arrayImages, id: \.self) { iconName in
                    Button {
                        selectedIconLibrary = iconName
                        print("\(selectedIconLibrary)")
                       // isShowIconGalary = false
                        
                    } label: {
                        Image(iconName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 65, height: 65)
                            .cornerRadius(5)
                            .padding()
                    }
                }
            }.padding()
        }
        
    }
    private func getAllImages(array: [CardModel]) -> [String]{
        var childrenArray: [String] = []
        childrenArray += array.compactMap { $0.imageName }
       
        for icon in array {
            if let children = icon.childCards {
                let imagesChildren = children.compactMap { $0.imageName }
                childrenArray += imagesChildren
            }
        }
        return childrenArray
    }
    

}
            
#Preview {
    IconLibraryView(isShowIconGalary: .constant(true), selectedIconLibrary: .constant("sun.max.fill"))
        .environmentObject(DM.shared)
}

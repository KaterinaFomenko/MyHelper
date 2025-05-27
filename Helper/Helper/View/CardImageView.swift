//
//  CardImageView.swift
//  Helper
//
//  Created by Катерина Фоменко on 18/04/2025.
//

import SwiftUI

struct CardImageView: View {
    let imageName: String?
    let fallImageName: String = "scribble"
    
    var body: some View {
        Group {
            // load From Local Catalog
            if let image = ImageService.shared.loadImageFromDiskWith(fileName: imageName) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: AppSize.cornerRadius))
                    //.background(Color.blue)
            } else {
                // load From JSON from Asset Catalog
                Image(imageName ?? fallImageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: AppSize.cornerRadius))
                  //  .background(Color.red)
            }
        }
    }
}

#Preview {
    CardImageView(imageName: "sunny")
}


//
//  TitleCardView.swift
//  Helper
//
//  Created by Катерина Фоменко on 17/05/2025.
//

import SwiftUI

struct TitleCardView: View {
    @EnvironmentObject var dm: DM
    @EnvironmentObject var settings: Settings
    
    let title: LocalizedStringResource
    
    var body: some View {
        Group {
            if dm.parentCardIdOpened < 0 {
                Text(title)
                    .transition(.opacity)
                    .id("TextIdentifier_\(dm.isCardContainGroup)")
            } else {
                let leng = settings.storedLanguage
                let nameOfGroupe = (dm.getNameOfGroup()).getLocalizedString(language: leng)
                Text(nameOfGroupe)
            }
        }
        .font(.custom("Helvetica Neue", size: AppSize.titleFont))
        .foregroundStyle(.gray)
        .lineLimit(1)
        .truncationMode(.tail) // add ...
        .animation(.snappy , value: dm.isCardContainGroup)
    }
}

#Preview {
    let testSpeechManager = SpeechManager(lang: Settings().storedLanguage)
    let dm = DM(speechManager: testSpeechManager)
    let settings = Settings()
    
    TitleCardView(title: "Create new Card")
        .environmentObject(dm)
        .environmentObject(settings)
}






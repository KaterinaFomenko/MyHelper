//
//  HelperApp.swift
//  Helper
//
//  Created by Катерина Фоменко on 09/02/2025.
//

import SwiftUI

@main
struct HelperApp: App {
   
    @StateObject var settings: Settings // = Settings()
    @StateObject var speechManager: SpeechManager
    @StateObject var dm: DM

    init() {
        let settings = Settings()
        let speechManager = SpeechManager(lang: settings.storedLanguage)
        _settings = StateObject(wrappedValue: settings)
        _speechManager = StateObject(wrappedValue: speechManager)
        _dm = StateObject(wrappedValue: DM(speechManager: speechManager))
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(settings)
                .environmentObject(speechManager)
                .environmentObject(dm)
                .environment(\.locale, settings.speechLanguage.locale)
                .id(settings.speechLanguage)
        }
    }
}

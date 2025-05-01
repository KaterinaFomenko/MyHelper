//
//  HelperApp.swift
//  Helper
//
//  Created by Катерина Фоменко on 09/02/2025.
//

import SwiftUI

@main
struct HelperApp: App {
    
    @StateObject var settings = Settings()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(settings)
                .environment(\.locale, settings.language.locale)
        }
    }
}

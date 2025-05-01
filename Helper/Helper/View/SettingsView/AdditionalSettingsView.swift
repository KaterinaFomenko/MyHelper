//
//  AdditionalSettingsView.swift
//  Helper
//
//  Created by Катерина Фоменко on 26/04/2025.
//

import SwiftUI

class Settings: ObservableObject {
    
    //@Published var language: Language = .english
    @Published var voiceGuidance: Bool = false
    @AppStorage("appLanguage") var language: Language = .english {
        willSet { objectWillChange.send() }
    }
    
    enum Language: String, CaseIterable, Identifiable {
        case english = "en"
        case polish = "pl"
        case russian = "ru"
        case ukrainian = "uk"
        
        var id: String { self.rawValue }
        
        var displayName: String {
            switch self {
            case .english: return "English"
            case .polish: return "Polski"
            case .russian: return "Русский"
            case .ukrainian: return "Українська"
            }
        }
        
         var locale: Locale {
            Locale(identifier: self.rawValue)
        }
    }
}


struct AdditionalSettingsView: View {
    @EnvironmentObject var settings: Settings
    @Binding var isShowAdditionalSettingsView: Bool
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Language") {
                    
                    Picker("Choice Language", selection: $settings.language) {
                        ForEach(Settings.Language.allCases) { language in
                            Text(language.displayName)
                        }
                    }
                    .pickerStyle(.navigationLink)
                }
                
                Section("Voice Guidance") {
                    Toggle("Do you want to use the audio?", isOn: $settings.voiceGuidance)
                }
            }
            .navigationTitle("Settins")
        }
    }
    
   
}

#Preview {
    let settings = Settings()
    AdditionalSettingsView( isShowAdditionalSettingsView: .constant(true))
        .environmentObject(settings)
}

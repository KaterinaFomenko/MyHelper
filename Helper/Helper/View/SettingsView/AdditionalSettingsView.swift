//
//  AdditionalSettingsView.swift
//  Helper
//
//  Created by Катерина Фоменко on 26/04/2025.
//

import SwiftUI

class Settings: ObservableObject {
    
    @Published var language: Language = .english
    @Published var voiceGuidance: Bool = false
    
    enum Language: String, CaseIterable {
        case english = "en"
        case polish = "pl"
        case russian = "rus"
        case ukrainian = "uk"
        
        var getLanguage: String {
            switch self {
            case .english: return "English"
            case .polish: return "Polisz"
            case .russian: return "Русский"
            case .ukrainian: return "Украінський"
            }
        }
    }
}


struct AdditionalSettingsView: View {
    @EnvironmentObject var settings: Settings
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Languge") {
                    
                    Picker("Choice Language", selection: $settings.language) {
                        ForEach(Settings.Language.allCases, id: \.self) { language in
                            Text(language.getLanguage)
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
    AdditionalSettingsView()
        .environmentObject(settings)
}

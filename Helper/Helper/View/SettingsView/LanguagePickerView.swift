//
//  LanguagePickerView.swift
//  Helper
//
//  Created by Катерина Фоменко on 26/04/2025.
//

import SwiftUI

class Settings: ObservableObject {
    @AppStorage("appLanguage") var storedLanguage: String = "en"
    @Published var voiceGuidance: Bool = false
    @Published var currentLanguage: Language {
           didSet {
               storedLanguage = currentLanguage.rawValue
           }
       }
    init() {
        let savedLang = UserDefaults.standard.string(forKey: "appLanguage") ?? "en"
       // let lang = Language(rawValue: storedLanguage) ?? .english
        self.currentLanguage = Language(rawValue: savedLang) ?? .english
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


struct LanguagePickerView: View {
    
    @EnvironmentObject var settings: Settings
    @EnvironmentObject var speechManager: SpeechManager
    @Binding var isShowLanguagePicker: Bool
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Language") {
                    
                    Picker("Language", selection: $settings.currentLanguage) {
                        ForEach(Settings.Language.allCases) { lang in
                            Text(lang.displayName)
                                .tag(lang)
                        }
                    }
                    .pickerStyle(.wheel)
                    .onChange(of: settings.currentLanguage) { oldValue, newValue in
                        print("🇲🇾 New Language is selected: \(newValue.displayName)")
                        speechManager.updateLanguage(to: newValue)
                        isShowLanguagePicker = false
                    }
                }
                
                Section("Voice Guidance") {
                    Toggle("Do you want to use the audio?", isOn: $settings.voiceGuidance)
                }
                
                .navigationTitle("Settings")
                .onChange(of: settings.voiceGuidance) { oldValue, newValue in
                    print("🔊 Voice guidance changed: \(settings.voiceGuidance)")
                    
                }
            }
        }
    }
    
    
}

#Preview {
    let settings = Settings()
    LanguagePickerView(isShowLanguagePicker: .constant(true))
        .environmentObject(settings)
}

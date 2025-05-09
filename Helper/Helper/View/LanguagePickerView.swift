//
//  LanguagePickerView.swift
//  Helper
//
//  Created by Катерина Фоменко on 26/04/2025.
//

import SwiftUI

class Settings: ObservableObject {
    @AppStorage("appLanguage") var storedLanguage: String = "en"
   // @Published var voiceGuidance: Bool = false
    @AppStorage("appVoiceGuidance") var voiceGuidance: Bool = false
    
    @Published var currentLanguage: Language {
           didSet {
               storedLanguage = currentLanguage.rawValue
           }
       }
    
 //   @StateObject var languageManager = LanguageManager()
    
    init() {
        let savedLang = UserDefaults.standard.string(forKey: "appLanguage") ?? "en"
        self.currentLanguage = Language(rawValue: savedLang) ?? .english
        print(self.currentLanguage)
      //  Locale(identifier: self.currentLanguage.rawValue)
     //   print(self.currentLanguage.rawValue)
        
      //  let savedVoiceGuidance = UserDefaults.standard.bool(forKey: "appVoiceGuidance")
        
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
                    .pickerStyle(.automatic)
                    .onChange(of: settings.currentLanguage) { oldValue, newValue in
                        print("🇲🇾 New Language is selected: \(newValue.displayName)")
                        speechManager.updateLanguage(to: newValue)
                      //  isShowLanguagePicker = false  / close screen
                    }
                }
                
                Section("Voice Guidance") {
                    Toggle("Do you want to use the audio?", isOn: $settings.voiceGuidance)
                }
                
                .navigationTitle("Settings")
                .onChange(of: settings.voiceGuidance) { oldValue, newValue in
                    print("🔊 Voice guidance changed: \(settings.voiceGuidance)")
                    print("🔊 Voice guidance changed: \(oldValue)")
                    print("🔊 Voice guidance changed: \(newValue)")
                }
            }
        }
    }
}
enum AppLanguage: String, CaseIterable {
    case en = "en"
    case ru = "ru"
    case es = "es"
    
    var displayName: String {
        switch self {
        case .en: return "English"
        case .ru: return "Русский"
        case .es: return "Español"
        }
    }
}
//class LanguageManager: ObservableObject {
//    @Published var currentLanguage: AppLanguage = .en
//    
//    func setLanguage(_ language: AppLanguage) {
//        currentLanguage = language
//        setAppLanguage(to: language.rawValue)
//    }
//}

#Preview {
    let settings = Settings()
    LanguagePickerView(isShowLanguagePicker: .constant(true))
        .environmentObject(settings)
}

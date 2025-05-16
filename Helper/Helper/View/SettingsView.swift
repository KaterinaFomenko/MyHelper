//
//  SettingsView.swift
//  Helper
//
//  Created by Катерина Фоменко on 26/04/2025.
//

import SwiftUI

class Settings: ObservableObject {
    @AppStorage("appLanguage") var storedLanguage: String = "en"
    @AppStorage("appVoiceGuidance") var voiceGuidance: Bool = true
    
    // Using for speechManager
    @Published var speechLanguage: Language {
        didSet {
            storedLanguage = speechLanguage.rawValue
        }
    }
    
    init() {
        let sytemLang = Locale.preferredLanguages.first ?? "en"
        let savedLang = UserDefaults.standard.string(forKey: "appLanguage") ?? sytemLang
        storedLanguage = savedLang
        self.speechLanguage = Language(rawValue: savedLang) ?? .english
        print(self.speechLanguage)
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
        
        var locale: Locale { // -> "en", "ru"
            Locale(identifier: self.rawValue)
        }
    }
}

struct SettingsView: View {
    @EnvironmentObject var settings: Settings
    @EnvironmentObject var speechManager: SpeechManager
    @State var tempLanguage: Settings.Language
    
    init(settings: Settings) {
        _tempLanguage = State(initialValue: settings.speechLanguage)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Language") {
                    
                    Picker("Language", selection: $tempLanguage) {
                        ForEach(Settings.Language.allCases) { lang in
                            Text(lang.displayName).tag(lang)
                        }
                    }
                    .pickerStyle(.navigationLink)
                    .onChange(of: tempLanguage) {_, newLang in
                        settings.speechLanguage = newLang
                        speechManager.updateLanguage(language: newLang.rawValue)
                    }
                }
                
                Section("Voice Guidance") {
                    Toggle("Do you want to use the audio?", isOn: $settings.voiceGuidance)
                }
                
                Section("Additional features") {
                    DisclosureGroup("Explanations") {
                        
                        HStack {
                            ChildCardImage(hasChildren: true)
                            Text("Blue dot means the card contains additional cards.")
                        }
                        
                        HStack {
                            
                            Image("plus")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25, height: 25)
                            Text("You can create new cards.")
                        }
                        Text("Long-press a card to edit or delete it.")
                    }
                }
                
                .navigationTitle("Settings")
                .onChange(of: settings.voiceGuidance) { oldValue, newValue in
                    print("🔊 Voice guidance changed: \(settings.voiceGuidance)")
                }
            }
        }
        
        .onDisappear() {
            settings.speechLanguage = tempLanguage
            speechManager.updateLanguage(language: tempLanguage.rawValue)
        }
    }
}

#Preview {
    let settings = Settings()
    SettingsView(settings: settings)
        .environmentObject(settings)
}

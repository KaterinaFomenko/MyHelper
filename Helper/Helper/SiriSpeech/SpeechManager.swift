
//  SpeechManager.swift
//  Helper
//
//  Created by Катерина Фоменко on 04/03/2025.


import Foundation
import AVFoundation

class SpeechManager: ObservableObject {
    private let synthesizer = AVSpeechSynthesizer()
    private var voiceIdentifier: String = ""
    
    init(lang: String) {
        updateLanguage(language: lang)
    }
    
    func updateLanguage(language: String) {
        
        let preferredVoiceName: String
        var locale = ""
   
        switch language {
        case "en":
            locale = "en-US"
            preferredVoiceName = "Samantha"
        case "pl":
            locale = "pl-PL"
            preferredVoiceName = "Zosia"
        case "ru":
            locale = "ru-RU"
            preferredVoiceName = "Milena"
        case "uk":
            locale = "uk-UA"
            preferredVoiceName = "Oksana"
        default:
            //prepare local for another language for search  optimal speech dictor // test german
            locale = getFixedLocale()
            preferredVoiceName = ""
        }
        
        let voices = AVSpeechSynthesisVoice.speechVoices().filter { $0.language == locale }
        print("🔍 Доступные голоса для \(locale): \(voices.map { $0.name })")
        
        // Пытаемся найти предпочтительный голос
        if let voice = voices.first(where: { $0.name.contains(preferredVoiceName) }) {
            voiceIdentifier = voice.identifier
            print("🌍 Используемый язык: \(voice.language)")
            print("✅ Голос: \(voice.name), ID: \(voiceIdentifier)")
        } else if let firstVoice = voices.first {
            voiceIdentifier = firstVoice.identifier
            print("⚠️ Предпочтительный голос не найден. Используется первый доступный: \(firstVoice.name)")
        } else {
            print("❌ Нет голосов для \(locale)")
            voiceIdentifier = ""
        }
    }
    
    func speak(text: String) {
        print("🟡 [SpeechManager] speak вызван с текстом: \(text)")
        print("🔤 Используемый voiceIdentifier: \(voiceIdentifier)")
        if text.isEmpty {
            print("🔴 [SpeechManager] Пустой текст для озвучки!")
            return
        }
        
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(identifier: voiceIdentifier)
        synthesizer.speak(utterance)
        
        if synthesizer.isSpeaking {
            print("⚠️ [SpeechManager] Синтезатор уже говорит, останавливаем...")
            synthesizer.stopSpeaking(at: .immediate)
        }
        print("🟠 [SpeechManager] synthesizer.speak вызван")
    }
    
    func getFixedLocale() -> String {
        let languageCode = Locale.preferredLanguages.first ?? "en"
        let regionCode = Locale.current.region?.identifier ?? "US"
        return "\(languageCode)-\(regionCode)"
    }
}

//
//  SpeechManager.swift
//  Helper
//
//  Created by Катерина Фоменко on 04/03/2025.
//

//import Foundation
//
//import AVFoundation
//
//class SpeechManager: ObservableObject {
//    private let synthesizer = AVSpeechSynthesizer()
//    @Published var isSpeaking = false
//    
//    var voiceIdentifier = "com.apple.voice.compact.en-US.Samantha"
//    var locale = ""
//    var voices = AVSpeechSynthesisVoice.speechVoices()
//    
//    // "ru-RU"
//    
//    init() {
//        // locale = "pl-PL"
//        locale = Locale.current.identifier.replacingOccurrences(of: "_", with: "-")
//        let filteredVoices = voices.filter { $0.language == locale }
//        
//        if filteredVoices.isEmpty {
//                print("❌ Нет голосов для locale: \(locale)")
//            } else {
//                voiceIdentifier = filteredVoices.first?.identifier ?? ""
//              //  print("✅ Найдены голоса \(locale)")
//                for voice in filteredVoices {
//                   // DM.shared.voiceIdentifier = voice.identifier   Junior Samantha
//                    if locale.contains("en") && voice.name.contains("Samantha") {
//                        voiceIdentifier = voice.identifier
//                    }
//                    print("✅ Voice Name: \(voice.name), Language: \(voice.language), Identifier: \(voice.identifier)")
//                }
//            }
//    }
//    
//    func speak(text: String) {
//        
//        let utterance = AVSpeechUtterance(string: text)
//        // Если указан voiceIdentifier — используем его
//        if let customVoice = AVSpeechSynthesisVoice(identifier: voiceIdentifier) {
//            utterance.voice = customVoice
//            print("✅ Используем голос по identifier: \(voiceIdentifier)")
//        } else {
//            if let defaultVoice = AVSpeechSynthesisVoice(language: locale) {
//                utterance.voice = defaultVoice
//                print("✅ Используем голос по locale: \(locale)")
//            } else {
//                print("⚠️ Не удалось подобрать голос, будет использован системный")
//            }
//        }
//        // Настройка скорости и тона (опционально)
//        utterance.rate = AVSpeechUtteranceDefaultSpeechRate // Скорость (0.0 до 1.0)
//        utterance.pitchMultiplier = 1.0 // Тон (0.5 до 2.0)
//        
//        synthesizer.speak(utterance)
//    }
//    
//    func stopSpeaking() {
//        synthesizer.stopSpeaking(at: .immediate)
//        isSpeaking = false
//    }
//    
//   
//    
//}

import Foundation
import AVFoundation

class SpeechManager: ObservableObject {
    private let synthesizer = AVSpeechSynthesizer()
    private var settings: Settings
    private var voiceIdentifier: String = ""

    init(settings: Settings) {
        self.settings = settings
        updateLanguage(to: settings.currentLanguage)
    }

    func updateLanguage(to language: Settings.Language) {
        let locale: String
        let preferredVoiceName: String
        
        switch language {
        case .english:
            locale = "en-US"
            preferredVoiceName = "Samantha" // Или "Nickey"
        case .polish:
            locale = "pl-PL"
            preferredVoiceName = "Zosia"
        case .russian:
            locale = "ru-RU"
            preferredVoiceName = "Milena"
        case .ukrainian:
            locale = "uk-UA"
            preferredVoiceName = "Oksana"
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
}

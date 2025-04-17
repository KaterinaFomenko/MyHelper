//
//  TextToSpeech.swift
//  Helper
//
//  Created by Катерина Фоменко on 04/03/2025.
//

import Foundation

import AVFoundation

class TextToSpeech {
    let synthesizer = AVSpeechSynthesizer()
    var voiceIdentifier = "com.apple.voice.compact.en-US.Samantha"
    var locale = ""
    var voices = AVSpeechSynthesisVoice.speechVoices()
    
    // "ru-RU"
    
    init() {
        // locale = "pl-PL"
        locale = Locale.current.identifier.replacingOccurrences(of: "_", with: "-")
        let filteredVoices = voices.filter { $0.language == locale }
        
        if filteredVoices.isEmpty {
                print("❌ Нет голосов для locale: \(locale)")
            } else {
                voiceIdentifier = filteredVoices.first?.identifier ?? ""
              //  print("✅ Найдены голоса \(locale)")
                for voice in filteredVoices {
                   // DM.shared.voiceIdentifier = voice.identifier   Junior Samantha
                    if locale.contains("en") && voice.name.contains("Samantha") {
                        voiceIdentifier = voice.identifier
                    }
                    print("✅ Voice Name: \(voice.name), Language: \(voice.language), Identifier: \(voice.identifier)")
                }
            }
    }
    
    func speak(text: String) {
        
        let utterance = AVSpeechUtterance(string: text)
        // Если указан voiceIdentifier — используем его
        if let customVoice = AVSpeechSynthesisVoice(identifier: voiceIdentifier) {
            utterance.voice = customVoice
            print("✅ Используем голос по identifier: \(voiceIdentifier)")
        } else {
            if let defaultVoice = AVSpeechSynthesisVoice(language: locale) {
                utterance.voice = defaultVoice
                print("✅ Используем голос по locale: \(locale)")
            } else {
                print("⚠️ Не удалось подобрать голос, будет использован системный")
            }
        }
        // Настройка скорости и тона (опционально)
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate // Скорость (0.0 до 1.0)
        utterance.pitchMultiplier = 1.0 // Тон (0.5 до 2.0)
        
        synthesizer.speak(utterance)
    }
    
   
    
}

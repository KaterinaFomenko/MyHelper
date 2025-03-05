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

    // "ru-RU"
    func speak(text: String, locale: String, voiceIdentifier: String) {
        let voices = AVSpeechSynthesisVoice.speechVoices()
        
        for voice in voices {
            
            //print("🎶Identifier: \(voice.identifier), Name: \(voice.name), Language: \(voice.language)")
        }
        
       
        let utterance = AVSpeechUtterance(string: text)
        
        if let voice = AVSpeechSynthesisVoice(identifier: voiceIdentifier) {
            utterance.voice = voice
            print("🎶🎶 custom voice")
        } else {
            utterance.voice = AVSpeechSynthesisVoice(language: locale)
            print("🎶🎶 standart voice")
        }
        
        utterance.voice = AVSpeechSynthesisVoice(language: locale)
        
        // Настройка скорости и тона (опционально)
           utterance.rate = AVSpeechUtteranceDefaultSpeechRate // Скорость (0.0 до 1.0)
           utterance.pitchMultiplier = 1.2 // Тон (0.5 до 2.0)
        
        synthesizer.speak(utterance)
    }
    
   
    
}
// speakText("Привет, как дела?", inLanguage: "ru-RU")

// Настройка скорости и тона
//    utterance.rate = 0.5 // Медленная речь
//    utterance.pitchMultiplier = 1.2 // Высокий тон

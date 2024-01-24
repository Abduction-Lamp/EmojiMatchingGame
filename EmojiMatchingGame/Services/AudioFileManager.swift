//
//  AudioFileManager.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 20.01.2024.
//

import Foundation
import AVFoundation

enum GameAudioScenario: SystemSoundID, CaseIterable {
    case flip       = 4163
    case navigation = 4323
    
    var path: String {
        let base = "/System/Library/Audio/UISounds/"
        switch self {
        case .flip:       return base + "nano/Detent_Haptic.caf"
        case .navigation: return base + "navigation_pop.caf"
        }
    }
}

protocol AudioFileManagerProtocol {
    func url(_ scenario: GameAudioScenario) -> URL?
}

final class AudioFileManager: AudioFileManagerProtocol {
    
    private var dictionaryAudioFiles: [GameAudioScenario : URL] = [:]
    
    static let instance: AudioFileManager = AudioFileManager()
    
    private init() {
        GameAudioScenario.allCases.forEach { scenario in
            if FileManager.default.fileExists(atPath: scenario.path),
               FileManager.default.isReadableFile(atPath: scenario.path) {
                dictionaryAudioFiles[scenario] = URL(fileURLWithPath: scenario.path)
            } else if let url = Bundle.main.url(forResource: scenario.rawValue.description, withExtension: "caf") {
                dictionaryAudioFiles[scenario] = url
            }
        }
        
        print("SERVICE\t\t🪗\tAudioFileManager")
    }
    
    deinit {
        print("SERVICE\t\t♻️\tAudioFileManager")
    }
    
    public func url(_ scenario: GameAudioScenario) -> URL? {
        dictionaryAudioFiles[scenario]
    }
}

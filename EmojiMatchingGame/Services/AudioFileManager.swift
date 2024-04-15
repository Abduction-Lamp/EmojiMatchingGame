//
//  AudioFileManager.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 20.01.2024.
//

import Foundation
import AVFoundation

enum GameAudioScenario: SystemSoundID, CaseIterable {
    case flip1       = 4163
    case flip2       = 4203
    case flip3       = 4233
    case flip4       = 4240
    case flip5       = 4268

    case match1      = 4251
    case match2      = 4182
    
    case navigation1 = 4323
    case navigation2 = 4319

    case menu1       = 4337
    case menu2       = 4238
    
    case fireworks1  = 4147
    case fireworks2  = 4151
    case fireworks3  = 4366

    
    var path: String {
        let base = "/System/Library/Audio/UISounds/"
        switch self {
        case .flip1       : return base + "nano/Detent_Haptic.caf"
        case .flip2       : return base + "nano/StopwatchStart_Haptic.caf"
        case .flip3       : return base + "nano/TimerCancel_Haptic.caf"
        case .flip4       : return base + "nano/UISwitch_Off_Haptic.caf"
        case .flip5       : return base + "nano/ET_RemoteTap_Send_Haptic.caf"
        case .match1      : return base + "nano/HourlyChime_Haptic.caf"
        case .match2      : return base + "nano/BatteryMagsafe_Haptic.caf"
        case .navigation1 : return base + "navigation_pop.caf"
        case .navigation2 : return base + "navigation_push.caf"
        case .menu1       : return base + "focus_change_keyboard.caf"
        case .menu2       : return base + "nano/HealthReadingFail_Haptic.caf"
        case .fireworks1  : return base + "nano/3rdParty_Success_Haptic.caf"
        case .fireworks2  : return base + "nano/Alarm_Nightstand_Haptic.caf"
        case .fireworks3  : return base + "New/Typewriters.caf"
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
    }

    
    public func url(_ scenario: GameAudioScenario) -> URL? {
        dictionaryAudioFiles[scenario]
    }
}

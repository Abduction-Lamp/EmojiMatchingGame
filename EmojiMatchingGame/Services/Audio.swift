//
//  Audio.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 14.01.2024.
//

import Foundation
import AVFoundation

protocol Audible {
    func play(_ scenario: GameAudioScenario)
}

final class AudioPlayer: Audible {
    
    private let audioFileManager = AudioFileManager.instance
    private var audioPlayer: AVAudioPlayer?
    private weak var appearence: AudioAppearanceProtocol?
    
    init(_ appearence: AudioAppearanceProtocol) {
        self.appearence = appearence
        print("SERVICE\t\t🪗\tAudioPlayer")
    }
    
    deinit {
        print("SERVICE\t\t♻️\tAudioPlayer")
    }
    
    func play(_ scenario: GameAudioScenario) {
        guard
            let appearence = appearence,
            appearence.sound
        else { return }
        
        if let url = audioFileManager.url(scenario) {
            do {
                try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
                try AVAudioSession.sharedInstance().setActive(true)
                
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.volume = appearence.volume
                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
}


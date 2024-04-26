//
//  Audio.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 14.01.2024.
//

import Foundation
import AVFoundation


protocol Audible: AnyObject {
    func play(_ scenario: GameAudioScenario)
    func stop()
}


final class AudioEngine: Audible {
    
    private let audioFileManager = AudioFileManager.instance

    private var engine: AVAudioEngine
    private var nodes: [AVAudioPlayerNode]
    
    private weak var appearence: AudioAppearanceProtocol?
    
    
    init(_ appearence: AudioAppearanceProtocol) {
        self.appearence = appearence
        engine = AVAudioEngine()
        nodes = []
    }
    
    
    // MARK: - Audible
    //
    public func play(_ scenario: GameAudioScenario) {
        guard let appearence = appearence, appearence.sound else { return }
        
        if let url = audioFileManager.url(scenario) {
            do {            
                let audioFile = try AVAudioFile(forReading: url)
                
                let node = AVAudioPlayerNode()
                engine.attach(node)
                engine.connect(node, to: engine.mainMixerNode, format: audioFile.processingFormat)

                node.scheduleFile(audioFile, at: nil, completionCallbackType: .dataPlayedBack) { [weak self] _ in
                    DispatchQueue.main.async {
                        guard let self = self else { return }
                        self.removeNode(node)
                    }
                }
                nodes.append(node)
                
                if !engine.isRunning {
                    engine.prepare()
                    try engine.start()
                }
                
                engine.mainMixerNode.outputVolume = appearence.volume
                node.play()
                
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    public func stop() {
        for node in nodes {
            node.stop()
            engine.detach(node)
        }
        engine.reset()
        engine.stop()
        nodes.removeAll()
    }

    private func removeNode(_ node: AVAudioPlayerNode) {
        if let index = nodes.firstIndex(of: node) {
            if engine.attachedNodes.contains(node) {
                engine.detach(node)
            }
            nodes.remove(at: index)
        }
    }
}

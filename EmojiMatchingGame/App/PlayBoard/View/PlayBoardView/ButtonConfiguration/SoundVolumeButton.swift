//
//  SoundVolumeButton.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 09.11.2023.
//

import UIKit

protocol SoundVolumeButtonCustomizable where Self: UIButton {
    
    associatedtype SoundVolumeType
    
    func setup(value: SoundVolumeType)
    func setup(value: Float)
}



final class SoundVolumeButton: UIButton, SoundVolumeButtonCustomizable {
    
    typealias SoundVolumeType = SoundVolume
    
    enum SoundVolume {
        case disabled, quiet, medium, loud, veryLoud
        
        var image: UIImage? {
            let systemName: String
            if #available(iOS 16, *) {
                systemName = _iOS16ImageName
            } else {
                systemName = _iOS14ImageName
            }
            return UIImage(systemName: systemName)
        }
        
        private var _iOS16ImageName: String {
            switch self {
            case .disabled: return "speaker.slash"
            case .quiet:    return "speaker"
            case .medium:   return "speaker.wave.1"
            case .loud:     return "speaker.wave.2"
            case .veryLoud: return "speaker.wave.3"
            }
        }
        
        private var _iOS14ImageName: String {
            switch self {
            case .disabled: return "speaker.slash.circle.fill"
            case .quiet:    return "speaker.circle.fill"
            case .medium:   return "speaker.circle.fill"
            case .loud:     return "speaker.wave.2.circle.fill"
            case .veryLoud: return "speaker.wave.2.circle.fill"
            }
        }
    }
    
    private func configure() -> UIButton.Configuration{
        var config = UIButton.Configuration.plain()
        config.image = SoundVolume.disabled.image
        config.baseForegroundColor = .systemRed
        config.contentInsets = Design.EdgeInsets.navigation.edge
        config.preferredSymbolConfigurationForImage = .init(textStyle: .largeTitle)
        
        return config
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configuration = configure()
        translatesAutoresizingMaskIntoConstraints = false
        adjustsImageSizeForAccessibilityContentSizeCategory = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("⚠️ \(Self.description()) init(coder:) has not been implemented")
    }
    
    public func setup(value: SoundVolume) {
        configuration?.image = value.image
    }
    
    public func setup(value: Float) {
        switch value {
        case 0                  : setup(value: .disabled)
        case .ulpOfOne ..< 0.15 : setup(value: .quiet)
        case 0.15      ..< 0.45 : setup(value: .medium)
        case 0.45      ..< 0.7  : setup(value: .loud)
        case 0.7       ... 1    : setup(value: .veryLoud)
        default                 : break
        }
    }
}

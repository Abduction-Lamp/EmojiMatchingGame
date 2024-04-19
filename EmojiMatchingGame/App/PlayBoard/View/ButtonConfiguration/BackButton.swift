//
//  BackButton.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 07.11.2023.
//

import UIKit

final class BackButton: UIButton {
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configuration = configure()
        translatesAutoresizingMaskIntoConstraints = false
        adjustsImageSizeForAccessibilityContentSizeCategory = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("⚠️ \(Self.description()) init(coder:) has not been implemented")
    }
    
    
    private func configure() -> UIButton.Configuration {
        let name: String
        if #available(iOS 16, *) {
            name = "arrowshape.backward"
        } else {
            name = "chevron.backward.circle.fill"
        }
        
        let img = UIImage(systemName: name)
        
        var config = UIButton.Configuration.plain()
        config.image = img
        config.baseForegroundColor = .systemRed
        config.contentInsets = Design.EdgeInsets.navigation.edge
        config.preferredSymbolConfigurationForImage = .init(textStyle: .largeTitle)
        
        return config
    }
}

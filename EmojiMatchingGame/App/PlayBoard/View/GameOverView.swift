//
//  GameOverView.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 08.09.2023.
//

import UIKit


final class GameOverView: UIView {
    
    private let blur: UIVisualEffectView = {
        let blur = UIVisualEffectView()
        blur.effect = UIBlurEffect(style: .light)
        blur.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return blur
    }()
    
    private let winLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.baselineAdjustment = .alignCenters
        label.textAlignment = .center
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 1
        label.adjustsFontForContentSizeCategory = true
        label.adjustsFontSizeToFitWidth = true
        label.font = .systemFont(ofSize: 1000)
        label.minimumScaleFactor = 0.02
        label.text = "🥳"
        return label
    }()
    
//    private(set) var repeatButton: UIButton = {
//        let img = UIImage(systemName: "arrow.counterclockwise")
//        let largeSymbolStyle = UIImage.SymbolConfiguration(textStyle: .largeTitle)
//
//        var config = UIButton.Configuration.tinted()
//        config.image = img
//        config.baseBackgroundColor = .black
//        config.baseForegroundColor = .black
//        config.contentInsets = .init(top: 20, leading: 20, bottom: 20, trailing: 20)
//        config.preferredSymbolConfigurationForImage = largeSymbolStyle
//
//        let button = UIButton()
//        button.configuration = config
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
    
    private(set) var nextLevelButton: UIButton = {
        let attributedText = NSAttributedString(
            string: "Следующий уровень",
            attributes: [.font: UIFont.boldSystemFont(ofSize: 27)]
        )
        
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .systemRed
        config.baseForegroundColor = .white
        config.contentInsets = .init(top: 20, leading: 20, bottom: 20, trailing: 20)
        config.buttonSize = .mini
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = config
        button.setAttributedTitle(attributedText, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configuration()
        
        print("\tVIEW:\t😈\tGameOverView")
    }
    
    deinit {
        print("\tVIEW:\t♻️\tGameOverView")
    }
    
    required init?(coder: NSCoder) {
        fatalError("⚠️ GameOverView init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        blur.frame = bounds
    }
    
    private func configuration() {
        layer.masksToBounds = true
        layer.cornerRadius = 20
        layer.opacity = 0
        
        addSubview(blur)
        addSubview(winLabel)
        addSubview(nextLevelButton)
        
        let separator:CGFloat = 20
        
        NSLayoutConstraint.activate([
            winLabel.topAnchor.constraint(equalTo: topAnchor, constant: separator),
            winLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: separator),
            winLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -separator),
            winLabel.bottomAnchor.constraint(equalTo: centerYAnchor, constant: -separator),
            nextLevelButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            nextLevelButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -separator)
        ])
    }

    func show() {
        nextLevelButton.isHidden = false
        winLabel.isHidden = false
        layer.opacity = 1
    }
    
    func hide() {
        nextLevelButton.isHidden = true
        winLabel.isHidden = true
        layer.opacity = 0
    }
}

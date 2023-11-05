//
//  MainMenuView.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 30.08.2023.
//

import UIKit

final class MainMenuView: UIView {
    
    private let gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.type = .axial
        gradient.setRandomProperty()
        return gradient
    }()
    private var isLocked = true
    
    
    private let stack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = Design.Spacing.menu.spacing
        return stack
    }()
    
    private(set) var newGameButton: UIButton = {
        let attributedText = NSAttributedString(
            string: "Новая игра",
            attributes: [.font: Design.Typography.menu.font]
        )
        
        var config = UIButton.Configuration.tinted()
        config.baseBackgroundColor = .white
        config.baseForegroundColor = .white
        config.contentInsets = .init(top: 20, leading: 75, bottom: 20, trailing: 75)
        config.buttonSize = .mini
        
        let button = UIButton()
        button.configuration = config
        button.setAttributedTitle(attributedText, for: .normal)
        return button
    }()
    
    private(set) var statisticsButton: UIButton = {
        let attributedText = NSAttributedString(
            string: "Статистика",
            attributes: [.font: Design.Typography.menu.font]
        )
        
        var config = UIButton.Configuration.tinted()
        config.baseBackgroundColor = .white
        config.baseForegroundColor = .white
        config.contentInsets = .init(top: 20, leading: 75, bottom: 20, trailing: 75)
        config.buttonSize = .mini
        
        let button = UIButton()
        button.configuration = config
        button.setAttributedTitle(attributedText, for: .normal)
        return button
    }()
    
    private(set) var settingsButton: UIButton = {
        let attributedText = NSAttributedString(
            string: "Настройки",
            attributes: [.font: Design.Typography.menu.font]
        )
        
        var config = UIButton.Configuration.tinted()
        config.baseBackgroundColor = .white
        config.baseForegroundColor = .white
        config.contentInsets = .init(top: 20, leading: 75, bottom: 20, trailing: 75)
        config.buttonSize = .mini
        
        let button = UIButton()
        button.configuration = config
        button.setAttributedTitle(attributedText, for: .normal)
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        
        print("\tVIEW:\t😈\tMenu")
    }
    
    deinit {
        print("\tVIEW:\t♻️\tMenu")
    }
    
    required init?(coder: NSCoder) {
        fatalError("⚠️ \(Self.description()) init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradient.frame = bounds
    }
    
    private func configure() {
        layer.addSublayer(gradient)
        
        addSubview(stack)
        stack.addArrangedSubview(newGameButton)
        stack.addArrangedSubview(statisticsButton)
        stack.addArrangedSubview(settingsButton)
        
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}


extension MainMenuView: GradientAnimatable {
    
    func animate(with duration: CFTimeInterval = 5) {
        if isLocked {
            isLocked = false
            transaction(with: duration)
        }
    }
    
    func stop() {
        isLocked = true
    }
    
    private func transaction(with duration: CFTimeInterval) {
        guard isLocked == false else { return }
        CATransaction.begin()
        CATransaction.setAnimationDuration(duration)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: .easeInEaseOut))
        CATransaction.setDisableActions(false)
        CATransaction.setCompletionBlock {
            let randomTimeInterval = CFTimeInterval(Int.random(in: 3...7))
            self.transaction(with: randomTimeInterval)
        }
        gradient.setRandomProperty()
        CATransaction.commit()
    }
}

//
//  MainMenuView.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 30.08.2023.
//

import UIKit

final class MainMenuView: UIView {
    
    private var isLocked = true
    private let gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.type = .axial
        gradient.setRandomProperty()
        return gradient
    }()
    
    private let stack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = Design.Padding.menu.spacing
        return stack
    }()

    private let newGame:  UIButton = makeButton(String(localized: "New Game"))
    private let results:  UIButton = makeButton(String(localized: "Results"))
    private let settings: UIButton = makeButton(String(localized: "Settings"))

    var newGameAction:    ((_: UIButton) -> Void)?
    var statisticsAction: ((_: UIButton) -> Void)?
    var settingsAction:   ((_: UIButton) -> Void)?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
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
        stack.addArrangedSubview(newGame)
        stack.addArrangedSubview(results)
        stack.addArrangedSubview(settings)
        
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
        
        newGame.addTarget(self, action: #selector(newGameTapped(_:)), for: .touchUpInside)
        results.addTarget(self, action: #selector(statisticsTapped(_:)), for: .touchUpInside)
        settings.addTarget(self, action: #selector(settingsTapped(_:)), for: .touchUpInside)
    }
}

extension MainMenuView {
    
    static private func makeButton(_ title: String) -> UIButton {
        let attributedText = NSAttributedString(
            string: title,
            attributes: [.font: Design.Typography.font(.menu)]
        )
        
        var config = UIButton.Configuration.tinted()
        config.baseBackgroundColor = .systemGray6
        config.baseForegroundColor = .systemGray6
        config.contentInsets = Design.EdgeInsets.menu.edge
        config.buttonSize = .mini
        
        let button = UIButton()
        button.configuration = config
        button.setAttributedTitle(attributedText, for: .normal)
        return button
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

extension MainMenuView: MainMenuSetupable {
    
    @objc
    private func newGameTapped(_ sender: UIButton) {
        newGameAction?(sender)
    }
    
    @objc
    private func statisticsTapped(_ sender: UIButton) {
        statisticsAction?(sender)
    }
    
    @objc
    private func settingsTapped(_ sender: UIButton) {
        settingsAction?(sender)
    }
}

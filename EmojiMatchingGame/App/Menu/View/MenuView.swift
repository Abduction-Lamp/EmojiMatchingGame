//
//  MenuView.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 30.08.2023.
//

import UIKit


final class MenuView: UIView {
    
    private(set) var gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.startPoint = .zero
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.locations = [0, 0.5, 1]
        gradient.colors = gradient.randomColors(for: 3)
        return gradient
    }()
    
    private let stack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 10
        return stack
    }()
    
    private(set) var newGameButton: UIButton = {
        let attributedText = NSAttributedString(
            string: "Новая игра",
            attributes: [.font: UIFont.boldSystemFont(ofSize: 27)]
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
            attributes: [.font: UIFont.boldSystemFont(ofSize: 27)]
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
            attributes: [.font: UIFont.boldSystemFont(ofSize: 27)]
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
        configuration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("⚠️ MenuView init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradient.frame = bounds
    }
    
    
    private func configuration() {
        layer.addSublayer(gradient)
        
        addSubview(stack)
        stack.addArrangedSubview(newGameButton)
        stack.addArrangedSubview(statisticsButton)
        stack.addArrangedSubview(settingsButton)
        
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
        ])
    }
}


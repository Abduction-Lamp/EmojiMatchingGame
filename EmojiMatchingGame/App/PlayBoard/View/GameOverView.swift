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
    
    private var winEmoji: String {
        let set: [String] = ["🥳", "🎊", "🎉", "🪅", "🏆"]
        let index: Int = Int.random(in: 0 ..< set.count)
        return set[index]
    }
    
    private let winLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.baselineAdjustment = .alignCenters
        label.textAlignment = .center
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 1
        label.adjustsFontForContentSizeCategory = true
        label.adjustsFontSizeToFitWidth = true
        label.font = .systemFont(ofSize: 500)
        label.minimumScaleFactor = 0.02
        label.text = "🥳"
        return label
    }()

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
    
    private lazy var fireworks: FireworksLayer = {
        let layer = FireworksLayer()
        layer.сonfiguration()
        layer.particles(with: makeFireworksParticles())
        return layer
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
        fatalError("⚠️ \(Self.description()) init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        blur.frame = bounds

        fireworks.layout(by: bounds, center: winLabel.center, radius: winLabel.bounds.height - layer.cornerRadius)
    }
    
    
    private func configuration() {
        addSubview(blur)
        addSubview(winLabel)
        addSubview(nextLevelButton)

        layer.cornerRadius = 25
        layer.addSublayer(fireworks)
        
        let separator: CGFloat = layer.cornerRadius
        NSLayoutConstraint.activate([
            winLabel.topAnchor.constraint(equalTo: topAnchor, constant: separator),
            winLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: separator),
            winLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -separator),
            winLabel.bottomAnchor.constraint(equalTo: centerYAnchor, constant: -separator),
            nextLevelButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            nextLevelButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -separator)
        ])
        
    }
}


extension GameOverView {
    
    func show() {
        winLabel.text = winEmoji
        nextLevelButton.isHidden = false
        winLabel.isHidden = false
        layer.opacity = 1
    }
    
    func hide() {
        nextLevelButton.isHidden = true
        winLabel.isHidden = true
        layer.opacity = 0
    }
    
    func firework() {
        let duration: CFTimeInterval = 2
        
        let springAnimation = CASpringAnimation(keyPath: "transform.scale")
        springAnimation.stiffness = 450
        springAnimation.mass = 2
        springAnimation.fromValue = 0.37
        springAnimation.toValue = 1

        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.fromValue = 0
        rotationAnimation.toValue = Float.pi * 4

        let group = CAAnimationGroup()
        group.animations = [springAnimation, rotationAnimation]
        group.duration = duration
        group.timingFunction = CAMediaTimingFunction(name: .easeOut)
        
        winLabel.layer.add(group, forKey: nil)
        fireworks.emit(duration: duration)
    }
    
    private func makeFireworksParticles() -> [EmittedParticle] {
        var particles: [EmittedParticle] = []
        
        if let glowplug = UIImage(systemName: "glowplug") {
            particles.append(.image(glowplug, size: nil, color: .systemGreen, birthRate: 23))
        }
        if let star = UIImage(systemName: "star.fill") {
            particles.append(.image(star, size: nil, color: .systemYellow, birthRate: 19))
        }
        if let party = UIImage(systemName: "party.popper") {
            particles.append(.image(party, size: nil, color: .systemIndigo, birthRate: 13))
        }
        
        let font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
        particles.append(.text("Браво!", font: font, color: .systemPink, birthRate: 3))
        particles.append(.text("🍬", font: font, color: nil, birthRate: 13))
        particles.append(.text("🎊", font: font, color: nil, birthRate: 11))
        particles.append(.text("🥳", font: font, color: nil, birthRate: 7))
        particles.append(.text("🎉", font: font, color: nil, birthRate: 7))
        particles.append(.text("🪅", font: font, color: nil, birthRate: 7))
        particles.append(.text("🍭", font: font, color: nil, birthRate: 7))
        particles.append(.text("🏆", font: font, color: nil, birthRate: 5))

        particles.append(.shape(.circle, size: .init(width: 4, height: 4), color: .systemRed, birthRate: 50))
        particles.append(.shape(.triangle, size: .init(width: 5, height: 5), color: .systemBlue, birthRate: 30))
        particles.append(.shape(.square, size: .init(width: 5, height: 5), color: .systemPurple, birthRate: 20))
        
        return particles
    }
}

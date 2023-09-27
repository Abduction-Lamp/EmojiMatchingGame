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
    
    
    private func makeFireworksParticles() -> [EmittedParticle] {
        var particles: [EmittedParticle] = []
        
        let glowplug = UIImage(systemName: "glowplug")
        let star     = UIImage(systemName: "star.fill")
        let party    = UIImage(systemName: "party.popper")
        
        if let glowplug = glowplug {
            particles.append(.image(glowplug, size: nil, color: .systemGreen, birthRate: 20))
        }
        if let star = star {
            particles.append(.image(star, size: nil, color: .systemYellow, birthRate: 13))
        }
        if let party = party {
            particles.append(.image(party, size: nil, color: .systemIndigo, birthRate: 13))
        }
        
        let font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
        particles.append(.text("Браво!", font: font, color: .systemPink, birthRate: 3))
        particles.append(.text("🎊", font: font, color: nil, birthRate: 17))
        particles.append(.text("🥳", font: font, color: nil, birthRate: 17))
        particles.append(.text("🎉", font: font, color: nil, birthRate: 7))

        particles.append(.shape(.circle, size: .init(width: 4, height: 4), color: .systemRed, birthRate: 40))
        particles.append(.shape(.triangle, size: .init(width: 5, height: 5), color: .systemBlue, birthRate: 30))
        
        return particles
    }
    
    
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

        fireworks.layout(by: bounds, center: winLabel.center, radius: winLabel.bounds.height - 20)
    }
    
    
    private func configuration() {
        layer.cornerRadius = 20
        
        addSubview(blur)
        addSubview(winLabel)
        addSubview(nextLevelButton)

        layer.addSublayer(fireworks)

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
}

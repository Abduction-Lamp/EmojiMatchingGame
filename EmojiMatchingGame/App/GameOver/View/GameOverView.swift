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
        blur.effect = UIBlurEffect(style: .systemMaterial)
        blur.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return blur
    }()
    
    private var quarter: CGFloat {
        return min(bounds.width, bounds.height) / 4
    }
        
    private var winEmoji: String {
        let set: [String] = ["🥳", "🎊", "🎉", "🪅", "🏆", "👑", "🦄"]
        let index: Int = Int.random(in: 0 ..< set.count)
        return set[index]
    }
    
    // MARK: Emoji Win Label
    private lazy var winLabel: UILabel = {
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
        label.text = winEmoji
        return label
    }()
    private var winLabelWidthAnchor: NSLayoutConstraint = .init()
    private var winLabelHeightAnchor: NSLayoutConstraint = .init()
    private var winLabelCenterYAnchor: NSLayoutConstraint = .init()

    private(set) var tapWinLabel: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer()
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        return tap
    }()

    
    // MARK: Time Label
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.baselineAdjustment = .alignCenters
        label.textAlignment = .center
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 2
        label.adjustsFontForContentSizeCategory = true
        label.adjustsFontSizeToFitWidth = true
        label.font = Design.Typography.title.font
        label.text = "⏱️\n"
        return label
    }()
    private var infoLabelCenterYAnchor: NSLayoutConstraint = .init()
    
    
    // MARK: Buttons
    private(set) var nextLevelButton: UIButton = {
        let img = UIImage(systemName: "play.fill")

        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .systemRed
        config.baseForegroundColor = .white
        config.contentInsets = Design.EdgeInsets.menu.edge
        config.buttonSize = .mini
        config.image = img
        config.preferredSymbolConfigurationForImage = .init(textStyle: .largeTitle)
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.adjustsImageSizeForAccessibilityContentSizeCategory = true
        button.configuration = config
        return button
    }()
    private var nextLevelButtonCenterYAnchor: NSLayoutConstraint = .init()
    
    private(set) var replayLevelButton: UIButton = {
        let img = UIImage(systemName: "arrow.counterclockwise")
        
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .systemBlue
        config.baseForegroundColor = .white
        config.contentInsets = Design.EdgeInsets.menu.edge
        config.buttonSize = .mini
        config.image = img
        config.preferredSymbolConfigurationForImage = .init(textStyle: .largeTitle)
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.adjustsImageSizeForAccessibilityContentSizeCategory = true
        button.configuration = config
        return button
    }()
    
    
    // MARK: Fireworks
    private lazy var fireworks: FireworksLayer = {
        let layer = FireworksLayer()
        layer.сonfiguration()
        layer.particles(with: makeFireworksParticles())
        return layer
    }()
    
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        
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
        fireworks.layout(by: winLabel.frame)
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        winLabelWidthAnchor.constant = quarter
        winLabelHeightAnchor.constant = quarter
        winLabelCenterYAnchor.constant = -quarter
        
        infoLabelCenterYAnchor.constant = 0.5 * quarter
        nextLevelButtonCenterYAnchor.constant = 1.5 * quarter
    }

    
    private func configure() {
        addSubview(blur)
        addSubview(winLabel)
        addSubview(infoLabel)
        addSubview(replayLevelButton)
        addSubview(nextLevelButton)

        layer.addSublayer(fireworks)
        
        winLabelWidthAnchor = winLabel.widthAnchor.constraint(equalToConstant: quarter)
        winLabelHeightAnchor = winLabel.heightAnchor.constraint(equalToConstant: quarter)
        winLabelCenterYAnchor = winLabel.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor, constant: -quarter)
        
        infoLabelCenterYAnchor = infoLabel.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor, constant: 0.5 * quarter)
        nextLevelButtonCenterYAnchor = nextLevelButton.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor, constant: 1.5 * quarter)
        
        NSLayoutConstraint.activate([
            winLabel.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            winLabelCenterYAnchor,
            winLabelWidthAnchor,
            winLabelHeightAnchor,
            
            infoLabel.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            infoLabel.heightAnchor.constraint(equalToConstant: infoLabel.font.height * 2),
            infoLabelCenterYAnchor,
            
            replayLevelButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor, constant: -Design.Padding.menu.spacing),
            replayLevelButton.centerYAnchor.constraint(equalTo: nextLevelButton.centerYAnchor),
            
            nextLevelButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor, constant: Design.Padding.menu.spacing),
            nextLevelButtonCenterYAnchor
        ])
        
        winLabel.isUserInteractionEnabled = true
        winLabel.addGestureRecognizer(tapWinLabel)
    }
}


extension GameOverView {
    
    func firework() {
        let duration: CFTimeInterval = 2
        
        let springAnimation = CASpringAnimation(keyPath: "transform.scale")
        springAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        springAnimation.stiffness = 1000
        springAnimation.mass = 5
        springAnimation.fromValue = 0.37
        springAnimation.toValue = 1

        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        rotationAnimation.fromValue = 0
        rotationAnimation.toValue = Float.pi * 6

        let group = CAAnimationGroup()
        group.animations = [springAnimation, rotationAnimation]
        group.timingFunction = CAMediaTimingFunction(name: .easeOut)
        group.duration = duration

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
        particles.append(.text("Браво!", font: font, color: .systemRed, birthRate: 3))
        particles.append(.text("🍬", font: font, color: nil, birthRate: 17))
        particles.append(.text("🦄", font: font, color: nil, birthRate: 11))
        particles.append(.text("🎊", font: font, color: nil, birthRate: 11))
        particles.append(.text("🥳", font: font, color: nil, birthRate: 7))
        particles.append(.text("🎉", font: font, color: nil, birthRate: 7))
        particles.append(.text("🪅", font: font, color: nil, birthRate: 7))
        particles.append(.text("🍭", font: font, color: nil, birthRate: 7))
        particles.append(.text("🏆", font: font, color: nil, birthRate: 5))
        particles.append(.text("👑", font: font, color: nil, birthRate: 3))

        particles.append(.shape(.circle, size: .init(width: 4, height: 4), color: .systemPink, birthRate: 53))
        particles.append(.shape(.triangle, size: .init(width: 5, height: 5), color: .systemBlue, birthRate: 31))
        particles.append(.shape(.square, size: .init(width: 5, height: 5), color: .systemGreen, birthRate: 23))
        
        return particles
    }
    
    func setup(time: String, taps: String, isFinishMode: Bool) {
        infoLabel.text = "⏱️\n" + time
        nextLevelButton.isEnabled = !isFinishMode
    }
}

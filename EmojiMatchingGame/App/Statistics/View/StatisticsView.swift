//
//  StatisticsView.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 23.11.2023.
//

import UIKit

final class StatisticsView: UIView {
    
    private let blur: UIVisualEffectView = {
        let blur = UIVisualEffectView()
        blur.effect = UIBlurEffect(style: .systemThickMaterial)
        blur.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return blur
    }()
    
    private let title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = Design.Typography.title.font
        label.textAlignment = .center
        label.text = "Результаты"
        return label
    }()
    
    private let stack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = Design.Padding.item.spacing
        return stack
    }()
    
    private let reset: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = "Сброс"
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var resetCenterXAnchor: NSLayoutConstraint = .init()

    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        print("\tVIEW:\t😈\tStatistics")
    }
    
    required init?(coder: NSCoder) {
        fatalError("⚠️ \(Self.description()) init(coder:) has not been implemented")
    }
    
    deinit {
        print("\tVIEW:\t♻️\tStatistics")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        blur.frame = bounds
        resetCenterXAnchor.constant = bounds.width/3
    }
    
    private func configure() {
        addSubview(blur)
        addSubview(title)
        addSubview(stack)
        addSubview(reset)
        
        let padding = Design.Padding.title.spacing

        resetCenterXAnchor = reset.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor, constant: 0)
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: padding),
            title.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            
            stack.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            
           // reset.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            resetCenterXAnchor,
            reset.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -padding)
        ])
    }
}
 

extension StatisticsView: StatisticsViewSetupable {
    
    func setup(level: UIImage? = nil,
               time:  String? = nil,
               taps:  String? = nil,
               font:  UIFont  = Design.Typography.item.font) {
        
        let item = UIStackView()
        item.axis = .horizontal
        item.alignment = .fill
        item.distribution = .fillEqually
        
        let levelImageView = UIImageView()
        levelImageView.contentMode = .scaleAspectFit
        levelImageView.image = level

        let timeLabel  = UILabel()
        timeLabel.textAlignment = .center
        timeLabel.font = font
        timeLabel.text = time
        
        let tapsLabel = UILabel()
        tapsLabel.textAlignment = .center
        tapsLabel.font = font
        tapsLabel.text = taps
        
        item.addArrangedSubview(levelImageView)
        item.addArrangedSubview(timeLabel)
        item.addArrangedSubview(tapsLabel)
        
        stack.addArrangedSubview(item)
    }
    
    func clean() {
        stack.arrangedSubviews.forEach { subviews in
            if subviews === stack.arrangedSubviews.first { return }
            if let item = subviews as? UIStackView {
                item.arrangedSubviews.forEach { cell in
                    item.removeArrangedSubview(cell)
                    cell.removeFromSuperview()
                }
                stack.removeArrangedSubview(item)
                item.removeFromSuperview()
            }
        }
    }
    
    func resetAddTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) {
        reset.addTarget(target, action: action, for: controlEvents)
    }
}

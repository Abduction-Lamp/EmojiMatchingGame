//
//  CardView.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 07.07.2023.
//

import UIKit

final class CardView: UIView {
    
    private let emoji: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        label.baselineAdjustment = .alignCenters
        label.textAlignment = .center
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 1
        label.adjustsFontForContentSizeCategory = true
        label.adjustsFontSizeToFitWidth = true
        label.font = .systemFont(ofSize: 500)
        label.minimumScaleFactor = 0.02
        label.isHidden = true
        label.backgroundColor = .clear
        return label
    }()
    
    private(set) var tap: UILongPressGestureRecognizer = {
        let tap = UILongPressGestureRecognizer()
        tap.minimumPressDuration = 0
        return tap
    }()
    
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        configuration()

        print("\tVIEW:\t😈\tCard")
    }
    
    deinit {
        print("\tVIEW:\t♻️\tCard")
    }
    
    required init?(coder: NSCoder) {
        fatalError("⚠️ \(Self.description()) init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height/4
    }
    
    
    private func configuration() {
        clipsToBounds = false
        backgroundColor = .systemYellow
        
        addSubview(emoji)
        NSLayoutConstraint.activate([
            emoji.topAnchor.constraint(equalTo: topAnchor),
            emoji.leadingAnchor.constraint(equalTo: leadingAnchor),
            emoji.trailingAnchor.constraint(equalTo: trailingAnchor),
            emoji.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        addGestureRecognizer(tap)
    }
}


extension CardView {
    
    private func changeState() {
        backgroundColor = emoji.isHidden ? .clear : .systemYellow
        emoji.isHidden = !emoji.isHidden
    }
    
    
    func flip(completion: ((Bool) -> Void)? = nil) {
        let duration: TimeInterval = 0.4
        
        UIView.transition(with: self, duration: duration, options: [.transitionFlipFromLeft, .curveEaseInOut]) { [weak self] in
            guard let self = self else { return }
            self.changeState()
        } completion: { isCompleted in
            guard let completion = completion else { return }
            completion(isCompleted)
        }
    }
    
    func shake(whih delay: CFTimeInterval = .zero) {
        let duration: CFTimeInterval = 0.06
        let shift: CGFloat = 7
        
        let animation = CABasicAnimation(keyPath: "position.x")
        animation.duration = duration
        animation.timeOffset = delay
        animation.repeatCount = 5
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.fromValue = center.x - shift
        animation.toValue = center.x + shift
        
        layer.add(animation, forKey: "shake")
    }
    
    func match(whih delay: CFTimeInterval = .zero, completion: ((Bool) -> Void)? = nil) {
        let scale: CGFloat = 1.25

        UIView.animate(withDuration: 0.15, delay: 0, options: [.curveEaseOut]) { [weak self] in
            guard let self = self else { return }
            self.transform = CGAffineTransform(scaleX: scale, y: scale)
        } completion: { _ in
            UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.25, options: [.curveEaseIn]) {
                self.transform = .identity
            } completion: { isSecondAnimationCompleted in
                guard let completion = completion else { return }
                completion(isSecondAnimationCompleted)
            }
        }
    }
    
    func setEmoji(_ emoji: String) {
        self.emoji.text = emoji
    }
    
    func select(_ isSelect: Bool) {
        if isSelect, emoji.isHidden {
            layer.shadowColor = UIColor.systemGray.cgColor
            layer.shadowOpacity = 0.8
            layer.shadowRadius = 4
            layer.shadowOffset = .zero
            layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
        } else {
            layer.shadowColor = nil
            layer.shadowOpacity = 0
            layer.shadowRadius = 0
            layer.shadowOffset = .zero
            layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
        }
    }
}

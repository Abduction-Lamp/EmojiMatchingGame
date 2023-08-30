//
//  CardView.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 07.07.2023.
//

import UIKit

final class CardView: UIView {
    
    private(set) var emoji: UILabel = {
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
        label.isHidden = true
        return label
    }()
    
    private(set) lazy var tap: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer()
        tap.numberOfTouchesRequired = 1
        tap.numberOfTapsRequired = 1
        return tap
    }()
    
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        configuration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("⚠️ CardView init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height/4
    }
    
    
    private func configuration() {
        layer.masksToBounds = true
        layer.backgroundColor = UIColor.systemYellow.cgColor

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
        UIView.transition(
            with: self,
            duration: 0.4,
            options: [.transitionFlipFromLeft, .curveEaseInOut]) { [weak self] in
                guard let self = self else { return }
                self.changeState()
            } completion: { isCompleted in
                guard let completion = completion else { return }
                completion(isCompleted)
            }
    }
    
    func shake(whih delay: CFTimeInterval = .zero) {
        let shift: CGFloat = 7
        let duration: CFTimeInterval = 0.05
        
        let animation = CABasicAnimation(keyPath: "position.x")
        animation.duration = duration
        animation.timeOffset = delay
        animation.repeatCount = 5
        animation.autoreverses = true
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.fromValue = center.x - shift
        animation.toValue = center.x + shift
        
        layer.add(animation, forKey: "shake")
    }
    
    func match(whih delay: CFTimeInterval = .zero) {
        let duration: TimeInterval = 0.15
        let scale: CGFloat = 1.25
        
        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: [.curveLinear],
            animations: {
                self.transform = CGAffineTransform(scaleX: scale, y: scale)
            },
            completion: { _ in
                UIView.animate(withDuration: duration) {
                    self.transform = .identity
                }
            })
    }
}

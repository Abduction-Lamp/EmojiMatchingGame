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
        label.textAlignment = .center
        label.baselineAdjustment = .alignCenters
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 1
        label.adjustsFontForContentSizeCategory = true
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.02
        label.font = .systemFont(ofSize: 500)
        label.isHidden = true
        return label
    }()
    
    private(set) var tap = UITapGestureRecognizer()
    
        
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
        backgroundColor = .systemRed

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

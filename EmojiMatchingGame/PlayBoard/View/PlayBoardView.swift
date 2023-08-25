//
//  PlayBoardView.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 05.07.2023.
//

import UIKit

final class PlayBoardView: UIView {
    
    private let board: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 5
        return stack
    }()
    
    private(set) var button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("new level", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemRed
        return button
    }()

    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configuration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("⚠️ PlayBoardView init(coder:) has not been implemented")
    }
    
    
    
    private func configuration() {
        backgroundColor = .systemBlue
        
        addSubview(board)
        addSubview(button)
        
        let margins: CGFloat = max(max(layoutMargins.left, layoutMargins.right), max(layoutMargins.top, layoutMargins.bottom))
        let width: CGFloat = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height) - margins
        
        
        NSLayoutConstraint.activate([
            board.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            board.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            board.widthAnchor.constraint(equalToConstant: width),
            board.heightAnchor.constraint(equalToConstant: width),
            
            button.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            button.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func remove() {
        board.arrangedSubviews.forEach { view in
            if let row = view as? UIStackView {
                row.arrangedSubviews.forEach { cell in
                    cell.removeFromSuperview()
                }
                row.removeFromSuperview()
            }
        }
    }
    
    func make(level: Level, with cards: [CardView]) {
        remove()
        
        if level.rawValue * level.rawValue == cards.count {
            var index = 0
            for _ in 0 ..< level.rawValue {
                let row = UIStackView()
                row.translatesAutoresizingMaskIntoConstraints = false
                row.axis = .horizontal
                row.distribution = .fillEqually
                row.spacing = board.spacing
                
                for _ in 0 ..< level.rawValue {
                    if index < cards.count {
                        row.addArrangedSubview(cards[index])
                        index += 1
                    }
                }
                board.addArrangedSubview(row)
            }
        }
    }
}

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
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = .init(top: 4, left: 4, bottom: 4, right: 4)
        
        stack.layer.masksToBounds = false
        stack.layer.backgroundColor = UIColor.systemGray6.cgColor
        stack.layer.opacity = 1
        stack.layer.cornerRadius = 25
        stack.layer.shadowColor = UIColor.systemGray.cgColor
        stack.layer.shadowOpacity = 0.7
        stack.layer.shadowRadius = 10
        stack.layer.shadowOffset = .zero
        
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 4
        
        return stack
    }()
    
    private var boardWidth: CGFloat {
        if UIScreen.main.bounds.width > UIScreen.main.bounds.height {
            return UIScreen.main.bounds.height - safeAreaInsets.top - safeAreaInsets.bottom
        } else {
            return UIScreen.main.bounds.width - directionalLayoutMargins.leading
        }
    }
    
    private var boardWidthAnchor: NSLayoutConstraint = .init()
    private var boardHeightAnchor: NSLayoutConstraint = .init()
    
    
    private(set) var backMenuButton: UIButton = {
        let img = UIImage(systemName: "text.justify")
        let largeSymbolStyle = UIImage.SymbolConfiguration(textStyle: .largeTitle)
        
        var config = UIButton.Configuration.plain()
        config.image = img
        config.baseForegroundColor = .systemRed
        config.contentInsets = .init(top: 17, leading: 17, bottom: 17, trailing: 17)
        config.preferredSymbolConfigurationForImage = largeSymbolStyle
        
        let button = UIButton()
        button.configuration = config
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configuration()
        
        print("\tVIEW:\t😈\tPlayBoard")
    }
    
    deinit {
        print("\tVIEW:\t♻️\tPlayBoard")
    }
    
    required init?(coder: NSCoder) {
        fatalError("⚠️ \(Self.description()) init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        board.layer.shadowPath = UIBezierPath(roundedRect: board.bounds, cornerRadius: board.layer.cornerRadius).cgPath
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        let width = boardWidth
        boardWidthAnchor.constant = width
        boardHeightAnchor.constant = width
    }
    
    
    private func configuration() {
        backgroundColor = .systemGray6
        
        addSubview(board)
        addSubview(backMenuButton)
        
        boardWidthAnchor = board.widthAnchor.constraint(equalToConstant: boardWidth)
        boardHeightAnchor = board.heightAnchor.constraint(equalToConstant: boardWidth)
        
        NSLayoutConstraint.activate([
            board.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            board.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            boardWidthAnchor,
            boardHeightAnchor,
            
            backMenuButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            backMenuButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor)
        ])
    }
}


extension PlayBoardView {
    
    func newGame(level: Level, with cards: [CardView]) {
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseInOut]) { [weak self] in
            guard let self = self else { return }
            board.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            board.layer.opacity = 0
        } completion: { _ in
            self.make(level: level, with: cards)
            
            UIView.animate(withDuration: 0.2) { [weak self] in
                guard let self = self else { return }
                self.board.transform = .identity
                self.board.layer.opacity = 1
            }
        }
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
    
    private func make(level: Level, with cards: [CardView]) {
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

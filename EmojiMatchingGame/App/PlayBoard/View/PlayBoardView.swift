//
//  PlayBoardView.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 05.07.2023.
//

import UIKit

final class PlayBoardView: UIView {
    
//    private let blur: UIVisualEffectView = {
//        let blur = UIVisualEffectView()
//        blur.effect = UIBlurEffect(style: .regular)
//        blur.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        return blur
//    }()
    
    private let board: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 5
        return stack
    }()
    
    private(set) var backMenuButton: UIButton = {
        let img = UIImage(systemName: "clear.fill")
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
    
    private(set) var gameOverView: GameOverView = {
        let view = GameOverView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = false
        view.layer.opacity = 0
        return view
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
        fatalError("⚠️ PlayBoardView init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        blur.frame = bounds
    }
    
    private func configuration() {
        backgroundColor = .white

//        addSubview(blur)
        addSubview(board)
        addSubview(gameOverView)
        addSubview(backMenuButton)
        
        let margins: CGFloat = max(max(layoutMargins.left, layoutMargins.right), max(layoutMargins.top, layoutMargins.bottom))
        let width: CGFloat = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height) - margins
        
        NSLayoutConstraint.activate([
            gameOverView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            gameOverView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            gameOverView.widthAnchor.constraint(equalToConstant: width),
            gameOverView.heightAnchor.constraint(equalToConstant: width),
            
            board.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            board.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            board.widthAnchor.constraint(equalToConstant: width),
            board.heightAnchor.constraint(equalToConstant: width),
            
            backMenuButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            backMenuButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor)
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
    
    func gameOverAnimatin() {
        UIView.animate(withDuration: 0.20, delay: 0.1, options: [.curveEaseInOut]) { [weak self] in
            guard let self = self else { return }
            self.gameOverView.show()
            self.board.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        }
    }
    
    func nextLevelAnimatin(completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: 0.20, delay: 0.1, options: [.curveEaseInOut]) { [weak self] in
            guard let self = self else { return }
            self.board.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            self.gameOverView.hide()
        } completion: { isCompletion in
            guard let completion = completion else { return }
            completion(isCompletion)
        }
    }
    
    func newGameAnimatin() {
        UIView.animate(withDuration: 0.20, delay: 0, options: [.curveEaseInOut]) { [weak self] in
            guard let self = self else { return }
            self.board.transform = .identity
        }
    }
}
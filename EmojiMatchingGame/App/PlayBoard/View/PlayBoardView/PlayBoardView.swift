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
        stack.layer.shadowRadius = 7
        stack.layer.shadowOffset = .zero
        
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 4
        
        return stack
    }()

    private var boardWidthAnchor: NSLayoutConstraint = .init()
    private var boardHeightAnchor: NSLayoutConstraint = .init()
    
    private(set) var backButton: UIButton = BackButton()
    private(set) var levelSegmentedControl: UISegmentedControl & LevelSegmentedCustomizable = LevelSegmentedControl()
    private(set) var soundVolumeButton: any UIButton & SoundVolumeButtonCustomizable = SoundVolumeButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        
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
        levelSegmentedControl.layer.shadowPath = UIBezierPath(roundedRect: levelSegmentedControl.bounds, cornerRadius: levelSegmentedControl.layer.cornerRadius).cgPath
    }
    
    override func updateConstraints() {
        updateConstraints(for: Design.PseudoUserInterfaceSizeClass.current)
        super.updateConstraints()
    }
    
    
    private func configure() {
        backgroundColor = .systemGray6
        
        addSubview(board)
        addSubview(backButton)
        addSubview(levelSegmentedControl)
        addSubview(soundVolumeButton)
        
        boardWidthAnchor = board.widthAnchor.constraint(equalToConstant: 0)
        boardHeightAnchor = board.heightAnchor.constraint(equalToConstant: 0)
        
        updateConstraints(for: Design.PseudoUserInterfaceSizeClass.current)

        NSLayoutConstraint.activate([
            board.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            board.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            boardWidthAnchor,
            boardHeightAnchor,
            
            backButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            backButton.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),

            levelSegmentedControl.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            levelSegmentedControl.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            levelSegmentedControl.heightAnchor.constraint(equalToConstant: 50),
            
            soundVolumeButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            soundVolumeButton.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor)
        ])
    }
    
    private func updateConstraints(for sizeClass: Design.PseudoUserInterfaceSizeClass) {
        let width: CGFloat
        
        switch sizeClass {
        case .compact:
            width = (UIScreen.main.bounds.width - directionalLayoutMargins.leading)
            levelSegmentedControl.isHidden = false
        case .regular:
            width = (UIScreen.main.bounds.height - safeAreaInsets.top - safeAreaInsets.bottom)
            levelSegmentedControl.isHidden = true
        }
        boardWidthAnchor.constant = width
        boardHeightAnchor.constant = width
    }
}

extension PlayBoardView: PlayBoardViewDisplayable {
    
    func setupLevelMenu(unlock: Indexable) {
        levelSegmentedControl.unlock(unlock)
    }
    
    func selectLevelMenu(level: Indexable) {
        levelSegmentedControl.select(level)
    }
    
    func playNewGame(level: Sizeable, with cards: [CardView], animated: Bool) {
        guard animated else {
            board.layer.opacity = 0
            make(level: level, with: cards)
            board.layer.opacity = 1
            return
        }
        
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
                    row.removeArrangedSubview(cell)
                    cell.removeFromSuperview()
                }
                board.removeArrangedSubview(row)
                row.removeFromSuperview()
            }
        }
    }
    
    private func make(level: Sizeable, with cards: [CardView]) {
        remove()
        
        if level.size * level.size == cards.count {
            var index = 0
            for _ in 0 ..< level.size {
                let row = UIStackView()
                row.translatesAutoresizingMaskIntoConstraints = false
                row.axis = .horizontal
                row.distribution = .fillEqually
                row.spacing = board.spacing
                
                for _ in 0 ..< level.size {
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

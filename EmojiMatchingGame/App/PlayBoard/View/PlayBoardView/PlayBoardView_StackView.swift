//
//  PlayBoardView_StackView.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 05.07.2023.
//

import UIKit

final class PlayBoardView_StackView: UIView {
    
    private let board: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = .init(top: 4, left: 4, bottom: 4, right: 4)
        
        stack.layer.masksToBounds = false
        stack.layer.opacity = 0
        
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 4
        
        return stack
    }()
    private var boardWidthAnchor: NSLayoutConstraint = .init()
    private var boardHeightAnchor: NSLayoutConstraint = .init()
    
    private(set) var levelMenu: UISegmentedControl & LevelSegmentedCustomizable = LevelSegmentedControl()
    private var levelMenuYAnchor: NSLayoutConstraint = .init()
    
    private(set) var backButton: UIButton = BackButton()
    private(set) var soundVolumeButton: any UIButton & SoundVolumeButtonCustomizable = SoundVolumeButton()


    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        
        print("\tVIEW\t😈\tPlayBoardView_StackView")
    }
    
    deinit {
        print("\tVIEW\t♻️\tPlayBoardView_StackView")
    }
    
    required init?(coder: NSCoder) {
        fatalError("⚠️ \(Self.description()) init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let path = UIBezierPath(roundedRect: levelMenu.bounds, cornerRadius: levelMenu.layer.cornerRadius).cgPath
        levelMenu.layer.shadowPath = path
    }
    
    override func updateConstraints() {
        updateConstraints(for: .current)
        super.updateConstraints()
    }
    
    
    private func configure() {
        backgroundColor = .systemGray6
        
        addSubview(board)
        addSubview(backButton)
        addSubview(levelMenu)
        addSubview(soundVolumeButton)
        
        boardWidthAnchor = board.widthAnchor.constraint(equalToConstant: 0)
        boardHeightAnchor = board.heightAnchor.constraint(equalToConstant: 0)
        
        levelMenuYAnchor = levelMenu.centerYAnchor.constraint(equalTo: backButton.centerYAnchor, constant: 0)
        
        NSLayoutConstraint.activate([
            board.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            board.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            boardWidthAnchor,
            boardHeightAnchor,
            
            backButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            backButton.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),

            levelMenu.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            levelMenuYAnchor,
            levelMenu.heightAnchor.constraint(equalToConstant: 50),
            
            soundVolumeButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            soundVolumeButton.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor)
        ])

        let current = Design.PseudoUserInterfaceSizeClass.current
        updateConstraints(for: .current)
        current == .compact ? showLevelMenu() : hiddenLevelMenu()
    }
    
    private func updateConstraints(for sizeClass: Design.PseudoUserInterfaceSizeClass) {
        let width: CGFloat = {
            switch sizeClass {
            case .compact: UIScreen.main.bounds.width - directionalLayoutMargins.leading
            case .regular: UIScreen.main.bounds.height - safeAreaInsets.top - safeAreaInsets.bottom
            }
        }()
        boardWidthAnchor.constant = width
        boardHeightAnchor.constant = width
    }
}


extension PlayBoardView_StackView: PlayBoardViewDisplayableDetails {
    
    func shiftLevelMenu() {
        levelMenuYAnchor.constant = self.levelMenu.frame.height
        layoutIfNeeded()
    }
    
    func hiddenLevelMenu() {
        levelMenuYAnchor.constant = -200
        layoutIfNeeded()
    }
    
    func showLevelMenu() {
        levelMenuYAnchor.constant = 0
        layoutIfNeeded()
    }
    
    func hiddenButtons() {
        backButton.transform = CGAffineTransform.init(translationX: -250, y: 0)
        soundVolumeButton.transform = CGAffineTransform.init(translationX: 250, y: 0)
    }
    
    func showButtons() {
        backButton.transform = .identity
        soundVolumeButton.transform = .identity
    }
    
    func hiddenBoard() {
        self.board.transform = CGAffineTransform(scaleX: -0.001, y: -0.001)
        self.board.layer.opacity = 0
    }
    
    func showBoard() {
        self.board.transform = .identity
        self.board.layer.opacity = 1
    }
    
    
    func setupLevelMenu(unlock: Indexable) {
        levelMenu.unlock(unlock)
    }
    
    func selectLevelMenu(level: Indexable) {
        levelMenu.select(level)
    }
}


extension PlayBoardView_StackView: PlayBoardViewDisplayable {

    func clean(animated: Bool, completion: (() -> Void)? = nil) {
        levelMenu.isUserInteractionEnabled = false
        guard animated else {
            board.layer.opacity = 0
            remove()
            completion?()
            return
        }
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut]) { [weak self] in
            guard let self = self else { return }
            self.hiddenBoard()
        } completion: { [weak self] _ in
            guard let self = self else { return }
            self.remove()
            completion?()
        }
    }
    
    func play(level: Sizeable, with cards: [CardView], animated: Bool) {
        make(level: level, with: cards)
        guard animated else {
            board.layer.opacity = 1
            levelMenu.isUserInteractionEnabled = true
            return
        }
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.showBoard()
        } completion: { [weak self] _ in
            guard let self = self else { return }
            self.levelMenu.isUserInteractionEnabled = true
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
        if level.size * level.size == cards.count {
            var index = 0
            for _ in 0 ..< level.size {
                let row = UIStackView()
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

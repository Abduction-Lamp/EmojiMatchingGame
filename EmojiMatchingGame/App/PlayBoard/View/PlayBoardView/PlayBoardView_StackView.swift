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
    
    private(set) var backButton: UIButton = BackButton()
    private(set) var levelSegmentedControl: UISegmentedControl & LevelSegmentedCustomizable = LevelSegmentedControl()
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
        
        let path = UIBezierPath(roundedRect: levelSegmentedControl.bounds, cornerRadius: levelSegmentedControl.layer.cornerRadius).cgPath
        levelSegmentedControl.layer.shadowPath = path
        
        
    }
    
    override func updateConstraints() {
        updateConstraints(for: .current)
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
        
        let sizeClass = Design.PseudoUserInterfaceSizeClass.current
        updateConstraints(for: sizeClass)

        switch sizeClass {
        case .compact: levelSegmentedControl.transform = .identity
        case .regular: levelSegmentedControl.transform = CGAffineTransform(translationX: 0, y: -100)
        }
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

extension PlayBoardView_StackView: PlayBoardViewDisplayable {

    func setupLevelMenu(unlock: Indexable) {
        levelSegmentedControl.unlock(unlock)
    }
    
    func selectLevelMenu(level: Indexable) {
        levelSegmentedControl.select(level)
    }
    
    func clean(animated: Bool, completion: (() -> Void)? = nil) {
        levelSegmentedControl.isUserInteractionEnabled = false
        
        guard animated else {
            board.layer.opacity = 0
            remove()
            completion?()
            return
        }
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut]) { [weak self] in
            guard let self = self else { return }
            self.board.transform = CGAffineTransform(scaleX: -0.001, y: -0.001)
            self.board.layer.opacity = 0
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
            levelSegmentedControl.isUserInteractionEnabled = true
            return
        }
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.board.transform = .identity
            self.board.layer.opacity = 1
        } completion: { [weak self] _ in
            guard let self = self else { return }
            self.levelSegmentedControl.isUserInteractionEnabled = true
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

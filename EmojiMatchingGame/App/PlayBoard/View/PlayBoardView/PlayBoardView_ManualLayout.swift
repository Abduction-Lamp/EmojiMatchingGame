//
//  PlayBoardView_ManualLayout.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 30.11.2023.
//

import UIKit

final class PlayBoardView_ManualLayout: UIView {
    
    private let board: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 25
        view.layer.shadowColor = UIColor.systemGray.cgColor
        view.layer.shadowOpacity = 0.7
        view.layer.shadowRadius = 7
        view.layer.shadowOffset = .zero
        return view
    }()
    
    private(set) var backButton: UIButton = BackButton()
    private(set) var levelSegmentedControl: UISegmentedControl & LevelSegmentedCustomizable = LevelSegmentedControl()
    private(set) var soundVolumeButton: any UIButton & SoundVolumeButtonCustomizable = SoundVolumeButton()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        
        print("\tVIEW\t😈\tPlayBoardView_ManualLayout")
    }
    
    deinit {
        print("\tVIEW\t♻️\tPlayBoardView_ManualLayout")
    }
    
    required init?(coder: NSCoder) {
        fatalError("⚠️ \(Self.description()) init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        board.frame = makeBoardFrame(for: .current)
        board.center = center
        board.layer.shadowPath = UIBezierPath(roundedRect: board.bounds, cornerRadius: board.layer.cornerRadius).cgPath
        
        levelSegmentedControl.layer.shadowPath = UIBezierPath(roundedRect: levelSegmentedControl.bounds, cornerRadius: levelSegmentedControl.layer.cornerRadius).cgPath
    }

    
    private func configure() {
        backgroundColor = .systemGray6
        
        addSubview(board)
        
        addSubview(backButton)
        addSubview(levelSegmentedControl)
        addSubview(soundVolumeButton)
    
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            backButton.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),

            levelSegmentedControl.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            levelSegmentedControl.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            levelSegmentedControl.heightAnchor.constraint(equalToConstant: 50),
            
            soundVolumeButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            soundVolumeButton.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor)
        ])
    }
}

extension PlayBoardView_ManualLayout: PlayBoardViewDisplayable {
    func setupSoundVolumeButton(volume: Float) {
        
    }
    
    
    func hiddenLevelMenu() {
    
    }
    
    func showLevelMenu() {
        
    }
    
    func shiftLevelMenu() {
        
    }
    
    func hiddenButtons() {
        
    }
    
    func showButtons() {
        
    }
    
    func hiddenBoard() {
        
    }
    
    func showBoard() {
        
    }
    
        
    func setupLevelMenu(unlock: Indexable) {
        levelSegmentedControl.unlock(unlock)
    }
    
    func selectLevelMenu(level: Indexable) {
        levelSegmentedControl.select(level)
    }
    
    func clean(animated: Bool, completion: (() -> Void)? = nil) {
        
        levelSegmentedControl.isUserInteractionEnabled = false
        guard animated else {
            board.isHidden = true
            completion?()
            return
        }
        
        let start = DispatchTime.now()
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.2)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: .easeInEaseOut))
        CATransaction.setDisableActions(false)
        CATransaction.setCompletionBlock {
            let end = DispatchTime.now()
            let nanoseconds = end.uptimeNanoseconds - start.uptimeNanoseconds
            let time = Double(nanoseconds) / 1_000_000_000
            print("UIView.animate:\t⏱️ \(time) seconds")
            
            completion?()
        }
        board.transform = CGAffineTransform(scaleX: -1, y: -1)
        board.layer.opacity = 0
        CATransaction.commit()
        
//        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseInOut]) { [weak self] in
//            guard let self = self else { return }
//            self.board.transform = CGAffineTransform(scaleX: -1, y: -1)
//            self.board.layer.opacity = 0
//        } completion: { _ in
//            
//            let end = DispatchTime.now()
//            let nanoseconds = end.uptimeNanoseconds - start.uptimeNanoseconds
//            let time = Double(nanoseconds) / 1_000_000_000
//            print("UIView.animate:\t⏱️ \(time) seconds")
//            
//            completion?()
//        }
    }
    
    func play(level: Sizeable, with cards: [CardView], animated: Bool) {
        addCardsToSubview(cards)
        make(level: level, with: cards)

        guard animated else {
            board.isHidden = false
            levelSegmentedControl.isUserInteractionEnabled = true
            return
        }
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let self = self else { return }
            self.board.transform = .identity
            self.board.layer.opacity = 1
        } completion: { [weak self] _ in
            guard let self = self else { return }
            self.levelSegmentedControl.isUserInteractionEnabled = true
        }
    }

    func make(level: Sizeable, with cards: [CardView]) {
        let size = makeCardSize(level: level, padding: 4)
        for (index, card) in cards.enumerated() {
            card.frame.origin = makeCardOriginPoint(for: index, level: level, size: size, padding: 4)
            card.frame.size = size
        }
    }
    
    private func addCardsToSubview(_ cards: [CardView]) {
        cards.forEach { board.addSubview($0) }
    }
    
    private func makeBoardFrame(for sizeClass: Design.PseudoUserInterfaceSizeClass) -> CGRect {
        var size: CGSize = .zero
        switch sizeClass {
        case .compact:
            size.width = bounds.width - directionalLayoutMargins.leading
        case .regular:
            size.width = bounds.height - safeAreaInsets.top - safeAreaInsets.bottom
        }
        size.height = size.width
        return .init(origin: .zero, size: size)
    }
    
    private func makeCardSize(level: Sizeable, padding: CGFloat) -> CGSize {
        var size: CGSize = .zero
        size.width = (board.bounds.width - CGFloat(level.size + 1) * padding) / CGFloat(level.size)
        size.height = size.width
        return size
    }
    
    private func makeCardOriginPoint(for index: Int, level: Sizeable, size: CGSize, padding: CGFloat) -> CGPoint {
        let xMultiplied: Int = index % level.size
        let yMultiplied: Int = index / level.size
        let x: CGFloat = padding + (padding + size.width) * CGFloat(xMultiplied)
        let y: CGFloat = padding + (padding + size.width) * CGFloat(yMultiplied)
        return .init(x: x, y: y)
    }
}

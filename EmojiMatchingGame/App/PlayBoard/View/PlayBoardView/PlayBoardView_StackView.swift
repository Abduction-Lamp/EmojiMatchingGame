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
        stack.layer.allowsEdgeAntialiasing = true
        
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 4
        
        return stack
    }()
    private var boardWidthAnchor: NSLayoutConstraint = .init()
    private var boardHeightAnchor: NSLayoutConstraint = .init()
    
    private var levelMenu: UISegmentedControl & LevelSegmentedCustomizable = LevelSegmentedControl()
    private var levelMenuYAnchor: NSLayoutConstraint = .init()
    
    private var backButton: UIButton = BackButton()
    private var soundVolumeButton: any UIButton & SoundVolumeButtonCustomizable = SoundVolumeButton()

    
    // MARK: - PlayBoardView Delegate
    weak var delegate: PlayBoardViewDelegate?
    
    
    // MARK: - Initional
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildUI()
        
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
    
    
    // MARK: - UI Building
    private func buildUI() {
        backgroundColor = .systemGray6
        
        addSubview(board)
        addSubview(levelMenu)
        addSubview(backButton)
        addSubview(soundVolumeButton)
        
        levelMenu.addTarget(self, action: #selector(lavelDidChange(_ : )), for: .valueChanged)
        backButton.addTarget(self, action: #selector(backButtonTapped(_ : )), for: .touchUpInside)
        soundVolumeButton.addTarget(self, action: #selector(soundVolumeButtonTapped(_:)), for: .touchUpInside)
        
        configure()
    }
    
    private func configure() {
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
        current == .compact ? showLevelMenu() : hideLevelMenu()
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


// MARK: - Displayable
extension PlayBoardView_StackView: PlayBoardViewDisplayable {
    
    func setupLevelMenu(unlock: Indexable) {
        levelMenu.unlock(unlock)
    }
    
    func selectLevelMenu(level: Indexable) {
        levelMenu.select(level)
    }
    
    func setupSoundVolumeButton(volume: Float) {
        soundVolumeButton.setup(volume: volume)
    }
    
    func clean(animated: Bool, completion: (() -> Void)? = nil) {
        levelMenu.isUserInteractionEnabled = false
        guard animated else {
            board.layer.opacity = 0
            remove()
            completion?()
            return
        }
                
        /// Синхронизируем анимацию и вызов звука скрытие игрового поля
        /// ---------------------------------------------------
        /// Если игральных карт много, то анимация стартует не сразу, есть небольшая задержка, видимо связана с вычислением кадра.
        /// Чтобы звук исчезновение игрового поля начался одновременно с началом анимацией
        /// создаем `displaylink`, который вызовет `callDisplayLinkForHideBoard` при первом кадре анимации.
        /// В `callDisplayLinkForHideBoard` вызывает соответствующий звук и сразу же инвалидирует `displaylink`, чтобы тот больше не вызывался
        ///
        let displaylink = CADisplayLink(target: self, selector: #selector(callDisplayLinkForHideBoard))
        displaylink.add(to: .main, forMode: .default)
        
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut]) { [weak self] in
            guard let self = self else { return }
            self.hideBoard()
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
        
        /// Синхронизируем анимацию и вызов звука скрытие игрового поля
        /// ---------------------------------------------------
        /// Если игральных карт много, то анимация стартует не сразу, есть небольшая задержка, видимо связана с вычислением кадра.
        /// Чтобы звук появление игрового поля начался одновременно с началом анимацией
        /// создаем `displaylink`, который вызовет `callDisplayLinkForHideBoard` при первом кадре анимации.
        /// В `callDisplayLinkForHideBoard` вызывает соответствующий звук и сразу же инвалидирует `displaylink`, чтобы тот больше не вызывался
        ///
        let displaylink = CADisplayLink(target: self, selector: #selector(callDisplayLinkForShowBoard))
        displaylink.add(to: .main, forMode: .default)
        
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut]) { [weak self] in
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


// MARK: - Actions for Will Transition
extension PlayBoardView_StackView {
    
    func hideLevelMenu() {
        levelMenuYAnchor.constant = -200
        layoutIfNeeded()
    }
    
    func showLevelMenu() {
        levelMenuYAnchor.constant = 0
        layoutIfNeeded()
    }
    
    func shiftLevelMenu() {
        levelMenuYAnchor.constant = levelMenu.frame.height
        layoutIfNeeded()
    }
    
    func hideButtons() {
        backButton.transform = CGAffineTransform.init(translationX: -250, y: 0)
        soundVolumeButton.transform = CGAffineTransform.init(translationX: 250, y: 0)
    }
    
    func showButtons() {
        backButton.transform = .identity
        soundVolumeButton.transform = .identity
    }
    
    func hideBoard() {
        board.transform = CGAffineTransform(scaleX: -0.001, y: -0.001)
        board.layer.opacity = 0
    }
    
    func showBoard() {
        board.transform = .identity
        board.layer.opacity = 1
    }
}


// MARK: - Delegate
extension PlayBoardView_StackView {
    
    @objc
    private func lavelDidChange(_ sender: UISegmentedControl) {
        delegate?.lavelDidChange(sender)
    }
    
    @objc
    private func backButtonTapped(_ sender: UIButton) {
        delegate?.backButtonTapped(sender)
    }

    @objc
    private func soundVolumeButtonTapped(_ sender: UIButton) {
        delegate?.soundVolumeButtonTapped(sender)
    }
}


// MARK: Synchronization using CADisplayLink
//
extension PlayBoardView_StackView {
    
    @objc
    private func callDisplayLinkForHideBoard(displaylink: CADisplayLink) {
        delegate?.soundGenerationToHideBoard()
        displaylink.invalidate()
    }
    
    @objc
    private func callDisplayLinkForShowBoard(displaylink: CADisplayLink) {
        delegate?.soundGenerationToShowBoard()
        displaylink.invalidate()
    }
}

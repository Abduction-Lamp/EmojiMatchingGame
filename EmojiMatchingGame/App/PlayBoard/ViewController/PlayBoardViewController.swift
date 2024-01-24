//
//  PlayBoardViewController.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 05.07.2023.
//

import UIKit

final class PlayBoardViewController: UIViewController {

    var presenter: PlayBoardPresentable?
    private var cards: [CardView] = []
    
    private var playBoardView: PlayBoardView_StackView {
        guard let view = self.view as? PlayBoardView_StackView else {
            return PlayBoardView_StackView(frame: self.view.frame)
        }
        return view
    }
    
    deinit {
        print("VC\t\t\t♻️\tPlayBoard")
    }
    
    override func loadView() {
        print("VC\t\t\t😈\tPlayBoard (loadView)")
        view = PlayBoardView_StackView()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        playBoardView.backButton.addTarget(self, action: #selector(backMenuButtonTapped(_:)), for: .touchUpInside)
        playBoardView.soundVolumeButton.addTarget(self, action: #selector(soundButtonTapped(_:)), for: .touchUpInside)
        playBoardView.levelMenu.addTarget(self, action: #selector(lavelDidChange(_:)), for: .valueChanged)
        
        presenter?.viewDidLoad()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        playBoardView.setNeedsUpdateConstraints()
        
        if size.width < size.height {
            coordinator.animate { _ in } completion: { [weak self] context in
                guard let self = self else { return }
                UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.85, options: [.curveEaseOut]) {
                    self.playBoardView.showLevelMenu()
                }
            }
        } else {
            playBoardView.hiddenLevelMenu()
        }
    }
    
    
//    //  MARK:   ManualLayout
//    //
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//
//        guard let presenter = presenter else { return }
//        playBoardView.make(level: presenter.level, with: cards)
//    }
}


extension PlayBoardViewController: PlayBoardDisplayable {

    func play(level: Sizeable, with sequence: [String], and color: UIColor, animated flag: Bool) {
        playBoardView.clean(animated: flag) { [weak self] in
            guard let self = self else { return }
//            //  MARK: ManualLayout
//            self.cards.forEach { $0.removeFromSuperview() }
//            //
            self.makeNewSetCards(sequence, color: color)
            self.playBoardView.play(level: level, with: cards, animated: flag)
        }
    }
    
    func setupLevelMenu(unlock: Indexable) {
        playBoardView.setupLevelMenu(unlock: unlock)
    }
    
    func selectLevelMenu(level: Indexable) {
        playBoardView.selectLevelMenu(level: level)
    }
    
    func setupSoundButton(volume: Float) {
        playBoardView.soundVolumeButton.setup(value: volume)
    }
    
    func disable(index first: Int, and second: Int) {
        cards[first].tap.isEnabled = false
        cards[second].tap.isEnabled = false
    }
    
    func flip(index: Int, animated flag: Bool, completion: ((Bool) -> Void)? = nil) {
        cards[index].flip(animated: flag, completion: completion)
    }
    
    func shaking(index first: Int, and second: Int, animated flag: Bool) {
        cards[first].shake(animated: flag)
        cards[second].shake(animated: flag)
    }
    
    func matching(index first: Int, and second: Int, animated flag: Bool, completion: ((Bool) -> Void)?) {
        cards[first].match(animated: flag)
        cards[second].match(animated: flag) { isCompleted in
            completion?(isCompleted)
        }
    }
    
    private func makeNewSetCards(_ sequence: [String], color: UIColor) {
        cards.removeAll()
        for emoji in sequence {
            let card = CardView()
            card.setup(emoji: emoji, color: color)
            card.tap.addTarget(self, action: #selector(cardTapped(_:)))
            self.cards.append(card)
        }
    }
}


extension PlayBoardViewController {

    @objc
    private func backMenuButtonTapped(_ sender: UIButton) {
        presenter?.goBackMainMenu()
    }

    @objc
    private func cardTapped(_ sender: UILongPressGestureRecognizer) {
        guard
            let card = sender.view as? CardView,
            let index = cards.firstIndex(of: card)
        else { return }
        
        let location = sender.location(in: card)
        let isInside: Bool = (location.x > 0) && (location.y > 0) && (location.x < card.bounds.width) && (location.y < card.bounds.height)
        
        switch sender.state {
        case .began:
            card.select(true)
        case .changed:
            if isInside { break }
            card.select(false)
            sender.state = .cancelled
        case .ended:
            card.select(false)
            presenter?.flip(index: index)
        default: 
            card.select(false)
        }
    }
    
    @objc
    private func lavelDidChange(_ sender: UISegmentedControl) {
        let level = sender.selectedSegmentIndex
        presenter?.play(mode: .index(level))
    }
    
    @objc
    private func soundButtonTapped(_ sender: UIButton) {
        presenter?.sound()
    }
}

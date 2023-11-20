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
    
    private var playBoardView: PlayBoardView {
        guard let view = self.view as? PlayBoardView else {
            return PlayBoardView(frame: self.view.frame)
        }
        return view
    }
    
    deinit {
        print("VC:\t\t\t♻️\tPlayBoard")
    }
    
    override func loadView() {
        print("VC:\t\t\t😈\tPlayBoard (loadView)")
        view = PlayBoardView()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        playBoardView.backButton.addTarget(self, action: #selector(backMenuButtonTapped(_:)), for: .touchUpInside)
        playBoardView.levelSegmentedControl.addTarget(self, action: #selector(lavelDidChange(_:)), for: .valueChanged)
        
        presenter?.viewDidLoad()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        playBoardView.setNeedsUpdateConstraints()
    }
}


extension PlayBoardViewController: PlayBoardDisplayable {

    func play(level: Sizeable, with sequence: [String], and color: UIColor, animated flag: Bool) {
        makeNewSetCards(sequence, color: color)
        playBoardView.playNewGame(level: level, with: cards, animated: flag)
    }
    
    func setupLevelMenu(unlock: Indexable) {
        playBoardView.setupLevelMenu(unlock: unlock)
    }
    
    func selectLevelMenu(level: Indexable) {
        playBoardView.selectLevelMenu(level: level)
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
        sequence.forEach { emoji in
            let card = CardView()
            card.setup(emoji: emoji, color: color)
            card.tap.addTarget(self, action: #selector(cardTaps(_:)))
            cards.append(card)
        }
    }
}


extension PlayBoardViewController {

    @objc
    private func backMenuButtonTapped(_ sender: UIButton) {
        presenter?.goBackMainMenu()
    }

    @objc
    private func cardTaps(_ sender: UILongPressGestureRecognizer) {
        guard
            let card = sender.view as? CardView,
            let index = cards.firstIndex(of: card)
        else { return }
        
        let location = sender.location(in: card)
        let isInside: Bool = location.x > 0 && location.y > 0 && location.x < card.bounds.width && location.y < card.bounds.height
        
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
        default: card.select(false)
        }
    }
    
    @objc
    private func lavelDidChange(_ sender: UISegmentedControl) {
        let level = sender.selectedSegmentIndex
        presenter?.play(mode: .index(level))
    }
}

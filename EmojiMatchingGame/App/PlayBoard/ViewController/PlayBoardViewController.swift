//
//  PlayBoardViewController.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 05.07.2023.
//

import UIKit


protocol PlayBoardDisplayable: AnyObject {
    
    var presenter: PlayBoardPresentable? { get set }
    
    func play(level: Level, with sequence: [String])
    
    func flipCard(index: Int, completion: ((Bool) -> Void)?)
    func shakingCards(index first: Int, and second: Int)
    func matchingCards(index first: Int, and second: Int, completion: ((Bool) -> Void)?)
    func disableCards(index first: Int, and second: Int)
    
    func isGameOver()
}


final class PlayBoardViewController: UIViewController {

    var presenter: PlayBoardPresentable?
    
    private var level: Level = .one
    private var cards: [CardView] = []
    
    private var playBoardView: PlayBoardView {
        guard let view = self.view as? PlayBoardView else {
            return PlayBoardView(frame: self.view.frame)
        }
        return view
    }
    
    
    override func loadView() {
        print("VC:\t\t\t😈\tPlayBoard (loadView)")
        view = PlayBoardView()
    }
    
    deinit {
        print("VC:\t\t\t♻️\tPlayBoard")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        playBoardView.backMenuButton.addTarget(self, action: #selector(backMenuButtonTapped(_:)), for: .touchUpInside)
        
        presenter?.play()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        playBoardView.setNeedsUpdateConstraints()
    }
}


extension PlayBoardViewController: PlayBoardDisplayable {
        
    func play(level: Level, with sequence: [String]) {
        newSetCards(sequence)
        playBoardView.newGame(level: level, with: cards)
    }
    
    func flipCard(index: Int, completion: ((Bool) -> Void)? = nil) {
        cards[index].flip(completion: completion)
    }
    
    func disableCards(index first: Int, and second: Int) {
        cards[first].tap.isEnabled = false
        cards[second].tap.isEnabled = false
    }
    
    func shakingCards(index first: Int, and second: Int) {
        cards[first].shake()
        cards[second].shake()
    }
    
    func matchingCards(index first: Int, and second: Int, completion: ((Bool) -> Void)?) {
        cards[first].match()
        cards[second].match { isCompletion in
            completion?(isCompletion)
        }
    }
    
    func isGameOver() {
        for card in cards {
            if card.tap.isEnabled { return }
        }
        
        
        let vc = GameOverViewController()
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    
    
    private func newSetCards(_ sequence: [String]) {
        cards.removeAll()
        sequence.forEach { emoji in
            let card = CardView()
            card.setEmoji(emoji)
            card.tap.addTarget(self, action: #selector(cardTaps(_:)))
            cards.append(card)
        }
    }
}


extension PlayBoardViewController {

    @objc
    private func backMenuButtonTapped(_ sender: UIButton) {
        presenter?.goToMenu()
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
}

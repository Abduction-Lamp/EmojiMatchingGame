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
        playBoardView.gameOverView.nextLevelButton.addTarget(self, action: #selector(nextLevelButtonTapped(_:)), for: .touchUpInside)
        
        presenter?.play()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
}


extension PlayBoardViewController: PlayBoardDisplayable {
        
    func play(level: Level, with sequence: [String]) {
        newSetCards(sequence)
        playBoardView.make(level: level, with: cards)
        playBoardView.newGameAnimatin()
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
        playBoardView.gameOverAnimatin()     
    }
    
    
    private func newSetCards(_ sequence: [String]) {
        cards.removeAll()
        sequence.forEach { emoji in
            let card = CardView()
            card.emoji.text = emoji
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
    private func nextLevelButtonTapped(_ sender: UIButton) {
        playBoardView.nextLevelAnimatin() { [weak self]_ in
            guard let self = self else { return }
            self.presenter?.nextLevel()
        }
    }
    
    @objc
    private func cardTaps(_ sender: UITapGestureRecognizer) {
        guard
            let card = sender.view as? CardView,
            let index = cards.firstIndex(of: card)
        else { return }
        presenter?.flip(index: index)
    }
}

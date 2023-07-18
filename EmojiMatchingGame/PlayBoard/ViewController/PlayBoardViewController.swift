//
//  PlayBoardViewController.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 05.07.2023.
//

import UIKit


protocol PlayBoardDisplayable: AnyObject {
    
    var presenter: PlayBoardPresentable? { get }
    
    func play(level: Level, with sequence: [String])
    func flip(index: Int)
    func disableCards(index first: Int, and second: Int)
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
        self.view = PlayBoardView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        playBoardView.button.addTarget(self, action: #selector(newLevelTapped(_:)), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
}


extension PlayBoardViewController {

    @objc
    private func newLevelTapped(_ sender: UIButton) {
        presenter?.play()
    }
    
    @objc
    private func cardTaps(_ sender: UIGestureRecognizer) {
        if let card = sender.view as? CardView,
           let index = cards.firstIndex(of: card) {
            presenter?.flip(index: index)
        }
    }
}


extension PlayBoardViewController: PlayBoardDisplayable {
    
    func play(level: Level, with sequence: [String]) {
        cards.removeAll()
        
        sequence.forEach { emoji in
            let card = CardView()
            card.emoji.text = emoji
            card.tap.addTarget(self, action: #selector(cardTaps(_:)))
            cards.append(card)
        }
        
        playBoardView.make(level: level, with: cards)
    }
    
    func flip(index: Int) {
        cards[index].flip()
    }
    
    func disableCards(index first: Int, and second: Int) {        
        cards[first].tap.isEnabled = false
        cards[second].tap.isEnabled = false
    }
}

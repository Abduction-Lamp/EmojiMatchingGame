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
    
    func flipCard(index: Int, completion: ((Bool) -> Void)?)
    func shakingCards(index first: Int, and second: Int)
    func matchingCards(index first: Int, and second: Int)
    func disableCards(index first: Int, and second: Int)
    
    func isGameOver() -> Bool
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


extension PlayBoardViewController: PlayBoardDisplayable {
    
    func play(level: Level, with sequence: [String]) {
        cards.removeAll()
        
        sequence.forEach { emoji in
            let card = CardView()
            card.emoji.text = emoji
            card.tap.addTarget(self, action: #selector(cardTaps(_:)))
            card.tap.delegate = self
            cards.append(card)
        }
        
        playBoardView.make(level: level, with: cards)
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
    
    func matchingCards(index first: Int, and second: Int) {
        cards[first].match()
        cards[second].match()
    }
    
    
    func isGameOver() -> Bool {
        for card in cards {
            if card.tap.isEnabled {
                return false
            }
        }
        return true
    }
}


extension PlayBoardViewController {

    @objc
    private func newLevelTapped(_ sender: UIButton) {
        presenter?.play()
    }
    
    @objc
    private func cardTaps(_ sender: UITapGestureRecognizer) {
        if let card = sender.view as? CardView,
           let index = cards.firstIndex(of: card) {
//            switch sender.state {
//            case .began: cards[index].backgroundColor = .black
//            case .ended: cards[index].backgroundColor = .systemYellow
//            default: break
//            }
            
            if let _ = card.layer.animationKeys() {
                return
            }
            
            presenter?.flip(index: index)
        }
    }
}


extension PlayBoardViewController: UIGestureRecognizerDelegate {
    
//    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//        if gestureRecognizer.state == .began { print(1)}
//        return true
//    }
//
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        switch touch.phase {
        case .began:         print("began")//; gestureRecognizer.view?.backgroundColor = .black
        case .ended:         print("ended")//;  gestureRecognizer.view?.backgroundColor = .cyan
        case .cancelled:     print("cancelled")
        case .moved:         print("moved")
        case .regionEntered: print("regionEntered")
        case .regionExited:  print("regionExited")
        case .regionMoved:   print("regionMoved")
        case .stationary:    print("stationary")
        @unknown default:
            print("@unknown")
        }
        return true
    }
    
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive press: UIPress) -> Bool {
//        switch press.phase {
//        case .began:         print("began"); gestureRecognizer.view?.backgroundColor = .black
//        case .ended:         print("ended");  gestureRecognizer.view?.backgroundColor = .cyan
//        case .cancelled:     print("cancelled")
//        case .stationary:    print("stationary")
//        case .changed:       print("changed")
//        @unknown default:
//            print("@unknown")
//        }
//        return true
//    }
    
//    func gestureRecognizer(UIGestureRecognizer, shouldReceive: UIEvent) -> Bool
}

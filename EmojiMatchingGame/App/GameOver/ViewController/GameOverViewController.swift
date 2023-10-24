//
//  GameOverViewController.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 05.10.2023.
//

import UIKit

final class GameOverViewController: UIViewController {
    
    private var gameOverView: GameOverView {
        guard let view = self.view as? GameOverView else {
            return GameOverView(frame: self.view.frame)
        }
        return view
    }
    
    var presenter: GameOverPresentable?
    
    
    override func loadView() {
        print("VC:\t\t\t😈\tGameOver (loadView)")
        view = GameOverView()
    }
    
    deinit {
        print("VC:\t\t\t♻️\tGameOver")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameOverView.nextLevelButton.addTarget(self, action: #selector(nextLevelButtonTapped(_:)), for: .touchUpInside)
        gameOverView.tapWinLabel.addTarget(self, action: #selector(winLabelTaps(_:)))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let animation = presenter?.doWithAnimation, animation else { return }
        gameOverView.firework()
    }
}


extension GameOverViewController: GameOverDisplayable {
    
    @objc
    private func nextLevelButtonTapped(_ sender: UIButton) {
        presenter?.nextLevel()
    }
    
    @objc
    private func winLabelTaps(_ sender: UITapGestureRecognizer) {
        guard let animation = presenter?.doWithAnimation, animation else { return }
        switch sender.state {
        case .ended: gameOverView.firework()
        default: break
        }
    }
}

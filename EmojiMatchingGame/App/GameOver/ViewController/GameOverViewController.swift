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
    
    override func loadView() {
        view = GameOverView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameOverView.nextLevelButton.addTarget(self, action: #selector(nextLevelButtonTapped(_:)), for: .touchUpInside)
        gameOverView.tapWinLabel.addTarget(self, action: #selector(winLabelTaps(_:)))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        gameOverView.firework()
    }
}

extension GameOverViewController {
    
    @objc
    private func nextLevelButtonTapped(_ sender: UIButton) {
        if let navigationVC = presentingViewController as? UINavigationController,
           let vc = navigationVC.topViewController as? PlayBoardViewController {
            dismiss(animated: true) {
                vc.presenter?.nextLevel()
            }
        } else {
            if let vc = presentingViewController as? PlayBoardViewController {
                dismiss(animated: true) {
                    vc.presenter?.nextLevel()
                }
            } else {
                dismiss(animated: true)
            }
        }
    }
    
    @objc
    private func winLabelTaps(_ sender: UITapGestureRecognizer) {
        switch sender.state {
        case .ended: gameOverView.firework()
        default: break
        }
    }
}

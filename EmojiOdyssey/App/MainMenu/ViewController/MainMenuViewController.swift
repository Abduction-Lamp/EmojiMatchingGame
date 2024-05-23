//
//  MainMenuViewController.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 30.08.2023.
//

import UIKit

final class MainMenuViewController: UIViewController {
    
    private var mainMenuView: UIView & MainMenuSetupable & GradientAnimatable {
        guard let view = self.view as? (UIView & MainMenuSetupable & GradientAnimatable) else {
            return MainMenuView(frame: self.view.frame)
        }
        return view
    }
    
    var presenter: MainMenuPresentable?

    override func loadView() {
        view = MainMenuView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainMenuView.newGameAction = newGameButtonTapped
        mainMenuView.settingsAction = settingsButtonTapped
        mainMenuView.statisticsAction = statisticsButtonTapped
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let presenter = self.presenter else { return }
        presenter.viewDidAppear()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        navigationController?.navigationBar.isHidden = false
        
        presenter?.viewDidDisappear()
        mainMenuView.stop()
    }
}


extension MainMenuViewController: MainMenuDisplayable {
    
    private func newGameButtonTapped(_ sender: UIButton) {
        presenter?.newGame()
    }
    
    private func settingsButtonTapped(_ sender: UIButton) {
        presenter?.settings()
    }
    
    private func statisticsButtonTapped(_ sender: UIButton) {
        presenter?.statistics()
    }
    
    func display(animated: Bool) {
        animated ? mainMenuView.animate(with: 5) : mainMenuView.stop()
    }
}

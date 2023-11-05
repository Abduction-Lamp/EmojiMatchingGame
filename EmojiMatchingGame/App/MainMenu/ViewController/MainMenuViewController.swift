//
//  MainMenuViewController.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 30.08.2023.
//

import UIKit

final class MainMenuViewController: UIViewController {
    
    private var mainMenuView: MainMenuView {
        guard let view = self.view as? MainMenuView else {
            return MainMenuView(frame: self.view.frame)
        }
        return view
    }
    
    var presenter: MainMenuPresentable?

    override func loadView() {
        print("VC:\t\t\t😈\tMenu (loadView)")
        view = MainMenuView()
    }
    
    deinit {
        print("VC:\t\t\t♻️\tMenu")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainMenuView.newGameButton.addTarget(self, action: #selector(newGameButtonTapped(_:)), for: .touchUpInside)
        mainMenuView.settingsButton.addTarget(self, action: #selector(settingsButtonTapped(_:)), for: .touchUpInside)
        mainMenuView.statisticsButton.addTarget(self, action: #selector(statisticsButtonTapped(_:)), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let presenter = self.presenter else { return }
        
        presenter.viewDidAppear()
        if !presenter.isAnimationLocked {
            mainMenuView.animate()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        navigationController?.navigationBar.isHidden = false
        
        presenter?.viewDidDisappear()
        mainMenuView.stop()
    }
}


extension MainMenuViewController: MainMenuDisplayable {
    
    @objc
    private func newGameButtonTapped(_ sender: UIButton) {
        presenter?.newGame()
    }
    
    @objc
    private func settingsButtonTapped(_ sender: UIButton) {
        presenter?.settings()
    }
    
    @objc
    private func statisticsButtonTapped(_ sender: UIButton) {
    }
    
    func update() {
        guard let presenter = self.presenter else { return }
        if presenter.isAnimationLocked {
            mainMenuView.stop()
        } else {
            mainMenuView.animate()
        }
    }
}

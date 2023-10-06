//
//  MainMenuViewController.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 30.08.2023.
//

import UIKit

protocol MainMenuDisplayable: AnyObject {
    
    var presenter: MainMenuPresentable? { get set }
}


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
        mainMenuView.animate()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.navigationBar.isHidden = false
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

        let vc = UIViewController()
        vc.view.backgroundColor = .systemGray6
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .formSheet
        
        mainMenuView.animate()
        present(vc, animated: true)
    }
    
    @objc
    private func statisticsButtonTapped(_ sender: UIButton) {
        let vc = UIViewController()
        vc.view.backgroundColor = .systemGray6
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .formSheet
        vc.preferredContentSize = .init(width: 100, height: 50)
        
        mainMenuView.stop()
        present(vc, animated: true)
    }
}

//
//  MenuViewController.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 30.08.2023.
//

import UIKit

protocol MenuDisplayable: AnyObject {
    
}


final class MenuViewController: UIViewController {
    
    private var menuView: MenuView {
        guard let view = self.view as? MenuView else {
            return MenuView(frame: self.view.frame)
        }
        return view
    }
    
    
    override func loadView() {
        view = MenuView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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

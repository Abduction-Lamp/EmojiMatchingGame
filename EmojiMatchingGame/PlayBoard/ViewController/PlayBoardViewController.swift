//
//  PlayBoardViewController.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 05.07.2023.
//

import UIKit

final class PlayBoardViewController: UIViewController {

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
    }
}

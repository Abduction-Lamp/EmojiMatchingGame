//
//  PlayBoardViewDelegate.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 29.01.2024.
//

import UIKit

protocol PlayBoardViewDelegate: AnyObject {
    
    func lavelDidChange(_ sender: UISegmentedControl)
    
    func backButtonTapped(_ sender: UIButton)
    func soundVolumeButtonTapped(_ sender: UIButton)
    
    func soundGenerationToHiddenBoard()
    func soundGenerationToShowBoard()
}

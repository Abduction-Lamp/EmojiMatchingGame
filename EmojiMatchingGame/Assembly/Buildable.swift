//
//  Buildable.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 04.09.2023.
//

import UIKit

protocol Buildable: AnyObject {
    
    func makeMenuFlow(router: Routable) -> UIViewController & MainMenuDisplayable
    func makePlayFlow(router: Routable) -> UIViewController & PlayBoardDisplayable
}

//
//  NavigationController.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 07.12.2023.
//

import UIKit

final class NavigationController: UINavigationController, UINavigationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        var transitioning: UIViewControllerAnimatedTransitioning? = nil
        switch operation {
        case .push: transitioning = PushAnimatedTransitioning()
        case .pop : transitioning = PopAnimatedTransitioning()
        default   : break
        }
        return transitioning
    }
}

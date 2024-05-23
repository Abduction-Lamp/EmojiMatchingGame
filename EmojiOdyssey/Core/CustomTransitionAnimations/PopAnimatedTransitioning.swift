//
//  PopAnimatedTransitioning.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 09.12.2023.
//

import UIKit

final class PopAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let duration: TimeInterval = 1
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let playBoardView = transitionContext.view(forKey: .from) as? PlayBoardView_StackView,
            let toView = transitionContext.view(forKey: .to)
        else { return }
        
        transitionContext.containerView.addSubview(toView)
        transitionContext.containerView.addSubview(playBoardView)
        toView.alpha = 1
        
        let current = Design.PseudoUserInterfaceSizeClass.current
        UIView.animateKeyframes(withDuration: duration, delay: 0) {
            if current == .compact {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.07) {
                    playBoardView.shiftLevelMenu()
                }
            }
            UIView.addKeyframe(withRelativeStartTime: 0.07, relativeDuration: 0.3) {
                if current == .compact {
                    playBoardView.hideLevelMenu()
                }
                playBoardView.hideButtons()
            }
            UIView.addKeyframe(withRelativeStartTime: 0.15, relativeDuration: 0.3) {
                playBoardView.hideBoard()
            }
            UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.6) {
                playBoardView.alpha = 0
            }
        } completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}

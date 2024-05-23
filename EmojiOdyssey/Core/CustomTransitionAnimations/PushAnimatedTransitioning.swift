//
//  PushAnimatedTransitioning.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 07.12.2023.
//

import UIKit

final class PushAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let duration: TimeInterval = 0.8
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromView = transitionContext.view(forKey: .from),
            let playBoardView = transitionContext.view(forKey: .to) as? PlayBoardView_StackView
        else { return }
        
        transitionContext.containerView.addSubview(playBoardView)
        transitionContext.containerView.addSubview(fromView)
    
        playBoardView.hideLevelMenu()
        playBoardView.hideButtons()
        
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModeCubicPaced) {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.4) {
                fromView.alpha = 0
            }
            UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 0.1) {
                playBoardView.showButtons()
            }
        } completion: { _ in
            if Design.PseudoUserInterfaceSizeClass.current == .compact {
                UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.45, initialSpringVelocity: 0.45, options: [.curveEaseOut]) {
                    playBoardView.showLevelMenu()
                }
            }
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}

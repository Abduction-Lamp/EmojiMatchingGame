//
//  CAGradientLayerExtention.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 31.08.2023.
//

import UIKit

extension CAGradientLayer {
    
    enum AnimationKey {
        case color, point, location, all
    }
    
    func animation(key: [AnimationKey] = [.all]) {
        let duration: CFTimeInterval = 4
        let timingFunction: CAMediaTimingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        let newColors = randomColors(for: colors?.count)
        let newLocation = generateLocation(for: colors?.count)
        let newGradientDirection = GradientDirection(start: GradientScreenPoint(startPoint), end: GradientScreenPoint(endPoint)).new()
    
        let colorAnimation = CABasicAnimation(keyPath: "colors")
        colorAnimation.fromValue = colors
        colorAnimation.toValue = newColors

        let locationAnimation = CABasicAnimation(keyPath: "locations")
        locationAnimation.fromValue = locations
        locationAnimation.toValue = newLocation

        let startPointAnimation = CABasicAnimation(keyPath: "startPoint")
        startPointAnimation.fromValue = startPoint
        startPointAnimation.toValue = newGradientDirection.direction.start
        
        let endPointAnimation = CABasicAnimation(keyPath: "endPoint")
        endPointAnimation.fromValue = endPoint
        endPointAnimation.toValue = newGradientDirection.direction.end
        
        let group = CAAnimationGroup()
        group.duration = duration
        group.timingFunction = timingFunction
        group.animations = [colorAnimation, startPointAnimation, endPointAnimation]
        group.setValue(newColors, forKey: "newColorsValue")
        group.setValue(newGradientDirection.direction.start, forKey: "newStartPointValue")
        group.setValue(newGradientDirection.direction.end, forKey: "newEndPointValue")
        group.delegate = self
        
        add(group, forKey: "GradientAnimation")
    }
}

extension CAGradientLayer: CAAnimationDelegate {

    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            if let newColors = anim.value(forKey: "newColorsValue") as? [Any] {
                colors = newColors
            }
            if let newStartPoint = anim.value(forKey: "newStartPointValue") as? CGPoint {
                startPoint = newStartPoint
            }
            if let newEndPoint = anim.value(forKey: "newEndPointValue") as? CGPoint {
                endPoint = newEndPoint
            }
            animation()
        }
    }
}

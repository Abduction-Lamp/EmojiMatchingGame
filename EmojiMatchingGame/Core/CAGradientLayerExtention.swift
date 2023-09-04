//
//  CAGradientLayerExtention.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 31.08.2023.
//

import UIKit

extension CAGradientLayer {
    
    func randomColors(for number: Int) -> [CGColor] {
        var allowedColors = [
            UIColor.systemBlue.cgColor,
            UIColor.systemBrown.cgColor,
            UIColor.systemCyan.cgColor,
            UIColor.systemGreen.cgColor,
            UIColor.systemIndigo.cgColor,
            UIColor.systemMint.cgColor,
            UIColor.systemOrange.cgColor,
            UIColor.systemPink.cgColor,
            UIColor.systemPurple.cgColor,
            UIColor.systemRed.cgColor,
            UIColor.systemTeal.cgColor,
            UIColor.systemYellow.cgColor
        ]
        guard number > 0, number <= allowedColors.count else { return [] }
        
        var output: [CGColor] = []
        for _ in 0 ..< number {
            let index = Int.random(in: 0 ..< allowedColors.count)
            output.append(allowedColors.remove(at: index))
        }
        return output
    }
    
    func randomLocation(for number: Int) -> [NSNumber] {
        guard number > 0 else { return [] }
        var output: [NSNumber] = []

        let step: Double = 1/Double(number)
        var begin: Double = 0

        for _ in 0 ..< number {
            let end = begin + step
            let location = Double.random(in: begin ..< end) as NSNumber
            begin = end
        
            output.append(location)
        }
        return output
    }
}
    

extension CAGradientLayer {
    
    enum AnimationKey {
        case color, point, location, all
    }
    
    func animation(key: [AnimationKey] = [.all]) {
        let duration: CFTimeInterval = 4
        
//        let group = CAAnimationGroup()
        
        let colorAnimation = CABasicAnimation()
        colorAnimation.keyPath = "colors"
        colorAnimation.duration = duration
        colorAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        colorAnimation.repeatCount = .infinity
        colorAnimation.autoreverses = true
        colorAnimation.fromValue = randomColors(for: 3)
        colorAnimation.toValue = randomColors(for: 3)
        
        let locationAnimation = CABasicAnimation()
        locationAnimation.keyPath = "locations"
        locationAnimation.duration = duration
        locationAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        locationAnimation.repeatCount = .infinity
        locationAnimation.autoreverses = true
        locationAnimation.fromValue = locations
        locationAnimation.toValue = randomLocation(for: 3)
        
        add(colorAnimation, forKey: "RandomGradientColors")
    }
}

//
//  CAGradientLayer+Randomized.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 08.09.2023.
//

import UIKit



extension CAGradientLayer {
        
    func randomColors(for number: Int?) -> [CGColor] {
        guard let number = number, number > 0, number < allowedSetColors.count else { return [] }
        var indexColor = (0 ..< allowedSetColors.count).map { $0 }
        var output: [CGColor] = []
        
        for _ in 0 ..< number {
            let index = indexColor.remove(at: .random(in: 0 ..< indexColor.count))
            output.append(allowedSetColors[index].cgColor)
        }
        return output
    }
    
    func generateLocation(for number: Int?) -> [NSNumber] {
        guard let number = number, number > 0, number < allowedSetColors.count else { return [] }
        var output: [NSNumber] = []
        output.append(0)
        
        let last = number - 1
        let step: Float = 1 / Float(number)
        var element: Float = step
        
        for _ in 1 ..< last {
            output.append(element as NSNumber)
            element += step
        }
        output.append(1)
        return output
    }
}

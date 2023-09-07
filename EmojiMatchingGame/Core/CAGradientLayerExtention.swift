//
//  CAGradientLayerExtention.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 31.08.2023.
//

import UIKit

extension CAGradientLayer {
    
    private var allowedSetColors: [UIColor] {
        [
            .systemBlue,
            .systemBrown,
            .systemCyan,
            .systemGreen,
            .systemIndigo,
            .systemMint,
            .systemOrange,
            .systemPink,
            .systemPurple,
            .systemRed,
            .systemTeal,
            .systemYellow,
            
            .red,
            .green,
            .blue,
            .cyan,
            .yellow,
            .magenta,
            .orange,
            .purple,
            .brown
        ]
    }
    

    enum GradientScreenPoint {

        //   CGPoint(x: 0, y: 0)     CGPoint(x: 0.5, y: 0)       CGPoint(x: 1, y: 0)
        //   CGPoint(x: 0, y: 0.5)                               CGPoint(x: 1, y: 0.5)
        //   CGPoint(x: 0, y: 1)     CGPoint(x: 0.5, y: 1)       CGPoint(x: 1, y: 1)
        
        case topLeft,       top,        topRight
        case left,                      right
        case bottomLeft,    bottom,     bottomRight

        var point: CGPoint {
            switch self {
            case .topLeft:      return CGPoint(x: 0,   y: 0)
            case .top:          return CGPoint(x: 0.5, y: 0)
            case .topRight:     return CGPoint(x: 1,   y: 0)
            case .left:         return CGPoint(x: 0,   y: 0.5)
            case .right:        return CGPoint(x: 1,   y: 0.5)
            case .bottomLeft:   return CGPoint(x: 0,   y: 1)
            case .bottom:       return CGPoint(x: 0.5, y: 1)
            case .bottomRight:  return CGPoint(x: 1,   y: 1)
            }
        }
        
        init(_ point: CGPoint) {
            let raw = (
                point.x == 0.5 ? point.x : round(point.x),
                point.y == 0.5 ? point.y : round(point.y)
            )
            
            switch raw {
            case (0, 0):   self = .topLeft
            case (0.5, 0): self = .top
            case (1, 0):   self = .topRight
            case (0, 0.5): self = .left
            case (1, 0.5): self = .right
            case (0, 1):   self = .bottomLeft
            case (0.5, 1): self = .bottom
            case (1,1):    self = .bottomRight
            default:       self = .top
            }
        }
    }

    enum GradientDirection: Int, CaseIterable {
        typealias ScreenCoordinate = (start: CGPoint, end: CGPoint)
        
        case topLeftBottomRight
        case topBottom
        case topRightBottomLeft
        case rightLeft
        case bottomRightTopLeft
        case bottomTop
        case bottomLeftTopRight
        case leftRight
        
        var direction: ScreenCoordinate {
            switch self {
            case .topLeftBottomRight:   return ScreenCoordinate(GradientScreenPoint.topLeft.point, GradientScreenPoint.bottomRight.point)
            case .topBottom:            return ScreenCoordinate(GradientScreenPoint.top.point, GradientScreenPoint.bottom.point)
            case .topRightBottomLeft:   return ScreenCoordinate(GradientScreenPoint.topRight.point, GradientScreenPoint.bottomLeft.point)
            case .rightLeft:            return ScreenCoordinate(GradientScreenPoint.right.point, GradientScreenPoint.left.point)
            case .bottomRightTopLeft:   return ScreenCoordinate(GradientScreenPoint.bottomRight.point, GradientScreenPoint.topLeft.point)
            case .bottomTop:            return ScreenCoordinate(GradientScreenPoint.bottom.point, GradientScreenPoint.top.point)
            case .bottomLeftTopRight:   return ScreenCoordinate(GradientScreenPoint.bottomLeft.point, GradientScreenPoint.topRight.point)
            case .leftRight:            return ScreenCoordinate(GradientScreenPoint.left.point, GradientScreenPoint.right.point)
            }
        }
        
        init(start: GradientScreenPoint, end: GradientScreenPoint) {
            switch (start, end) {
            case (.topLeft, .bottomRight):  self = .topLeftBottomRight
            case (.top, .bottom):           self = .topBottom
            case (.topRight, .bottomLeft):  self = .topRightBottomLeft
            case (.right, .left):           self = .rightLeft
            case (.bottomRight, .topLeft):  self = .bottomRightTopLeft
            case (.bottom, .top):           self = .bottomTop
            case (.bottomLeft, .topRight):  self = .bottomLeftTopRight
            case (.left, .right):           self = .leftRight
            default:                        self = .topBottom
            }
        }
        
        
        func new() -> GradientDirection {
            let maxCountRawValue = GradientDirection.allCases.count
            let dispersion = -2...2

            var newRawValue = self.rawValue + Int.random(in: dispersion)

            if newRawValue < 0 {
                newRawValue = maxCountRawValue + newRawValue
            }
            
            if newRawValue >= maxCountRawValue {
                newRawValue = newRawValue - maxCountRawValue
            }
            
            guard let newGradientDirection = GradientDirection(rawValue: newRawValue) else { return self }
            return newGradientDirection
        }
    }
    
    
    
    
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
    
    func randomCGPoint() -> CGPoint {
        return CGPoint(x: .random(in: 0...1), y: .random(in: 0...1))
    }
}
    

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

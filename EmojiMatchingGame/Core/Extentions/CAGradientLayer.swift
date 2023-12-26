//
//  CAGradientLayer.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 08.09.2023.
//

import UIKit

extension CAGradientLayer {
    
    private var allowedSetColors: [[UIColor]] {
        [
            [.blue, .systemBlue, .systemIndigo, .cyan, .systemCyan, .systemMint, .systemTeal],
            [.brown, .systemBrown, .yellow, .orange, .systemYellow, .systemOrange],
            [.green, .systemGreen],
            [.purple, .systemPurple, .red, .systemPink, .systemRed, .magenta]
        ]
    }
    
    /// Именованные координаты некоторых точек пространства
    ///
    /// Координаты начинаются в левом верхнем углу точка (0, 0) и заканчиваются в правом нижнем углу с координатой (1, 1)
    /// Эта система координат используется для задания начальной и конечной точки направления градиента - startPoint и endPoint
    ///
    /// Решая задачу анимации градиента, были выбраны некоторые опорные точки,
    /// от одной точки к другой будет меняться направление слоя градиента
    ///
    /// Координаты опорных точки:                   Именованные значения опорных точки:
    ///   (0, 0)      (0.5, 0)    (1, 0)                              topLeft             top             topRight
    ///   (0, 0.5)                  (1, 0.5)                           left                                      right
    ///   (0, 1)      (0, 0.5)    (1, 1)                              bottomLeft      bottom        bottomRight
    ///
    private enum GradientScreenPoint {
        
        case topLeft,       top,        topRight
        case left,                      right
        case bottomLeft,    bottom,     bottomRight
        
        var point: CGPoint {
            switch self {
            case .topLeft:     CGPoint(x: 0,   y: 0)
            case .top:         CGPoint(x: 0.5, y: 0)
            case .topRight:    CGPoint(x: 1,   y: 0)
            case .left:        CGPoint(x: 0,   y: 0.5)
            case .right:       CGPoint(x: 1,   y: 0.5)
            case .bottomLeft:  CGPoint(x: 0,   y: 1)
            case .bottom:      CGPoint(x: 0.5, y: 1)
            case .bottomRight: CGPoint(x: 1,   y: 1)
            }
        }
        
        ///  Преобразует любой CGPoint в опорную точку по правилам округления
        init(_ point: CGPoint) {
            let raw = (
                point.x == 0.5 ? point.x : round(point.x),
                point.y == 0.5 ? point.y : round(point.y)
            )
            switch raw {
            case (...0, ...0): self = .topLeft
            case (0.5, ...0) : self = .top
            case (1..., ...0): self = .topRight
            case (...0, 0.5) : self = .left
            case (1..., 0.5) : self = .right
            case (...0, 1...): self = .bottomLeft
            case (0.5, 1...) : self = .bottom
            case (1..., 1...): self = .bottomRight
            default:           self = .top
            }
        }
    }
    
    
    /// Направления распространения градиента
    private enum GradientDirection: Int, CaseIterable {
        typealias ScreenCoordinate = (start: CGPoint, end: CGPoint)
        
        case topLeftToBottomRight
        case topToBottom
        case topRightToBottomLeft
        case rightToLeft
        case bottomRightToTopLeft
        case bottomToTop
        case bottomLeftToTopRight
        case leftToRight
        
        var direction: ScreenCoordinate {
            switch self {
            case .topLeftToBottomRight: ScreenCoordinate(GradientScreenPoint.topLeft.point, GradientScreenPoint.bottomRight.point)
            case .topToBottom:          ScreenCoordinate(GradientScreenPoint.top.point, GradientScreenPoint.bottom.point)
            case .topRightToBottomLeft: ScreenCoordinate(GradientScreenPoint.topRight.point, GradientScreenPoint.bottomLeft.point)
            case .rightToLeft:          ScreenCoordinate(GradientScreenPoint.right.point, GradientScreenPoint.left.point)
            case .bottomRightToTopLeft: ScreenCoordinate(GradientScreenPoint.bottomRight.point, GradientScreenPoint.topLeft.point)
            case .bottomToTop:          ScreenCoordinate(GradientScreenPoint.bottom.point, GradientScreenPoint.top.point)
            case .bottomLeftToTopRight: ScreenCoordinate(GradientScreenPoint.bottomLeft.point, GradientScreenPoint.topRight.point)
            case .leftToRight:          ScreenCoordinate(GradientScreenPoint.left.point, GradientScreenPoint.right.point)
            }
        }
        
        init(start: GradientScreenPoint, end: GradientScreenPoint) {
            switch (start, end) {
            case (.topLeft, .bottomRight): self = .topLeftToBottomRight
            case (.top, .bottom):          self = .topToBottom
            case (.topRight, .bottomLeft): self = .topRightToBottomLeft
            case (.right, .left):          self = .rightToLeft
            case (.bottomRight, .topLeft): self = .bottomRightToTopLeft
            case (.bottom, .top):          self = .bottomToTop
            case (.bottomLeft, .topRight): self = .bottomLeftToTopRight
            case (.left, .right):          self = .leftToRight
            default:                       self = .topToBottom
            }
        }
        
        func new() -> GradientDirection {
            let maxCountRawValue = GradientDirection.allCases.count
            let dispersion = -2...2
            
            var newRawValue = self.rawValue + Int.random(in: dispersion)
            
            if newRawValue < 0 {
                newRawValue = newRawValue + maxCountRawValue
            }
            
            if newRawValue >= maxCountRawValue {
                newRawValue = newRawValue - maxCountRawValue
            }
            
            guard let newGradientDirection = GradientDirection(rawValue: newRawValue) else { return self }
            return newGradientDirection
        }
    }
}


extension CAGradientLayer {
        
    private func randomAllowedColors(for number: Int?) -> [CGColor] {
        guard let number = number, number > 0, number < allowedSetColors.count else { return [] }
        var indexSetColors = (0 ..< allowedSetColors.count).map { $0 }
        var output: [CGColor] = []
        
        for _ in 0 ..< number {
            let indexSet = indexSetColors.remove(at: .random(in: 0 ..< indexSetColors.count))
            let index = Int.random(in: 0 ..< allowedSetColors[indexSet].count)
            output.append(allowedSetColors[indexSet][index].cgColor)
        }
        return output
    }
    
    private func randomColors() -> [CGColor] {
        var set: [CGColor] = []
        let count: Int = colors?.count ?? 2
        for _ in 0 ..< count {
            set.append(UIColor.random().cgColor)
        }
        return set
    }
    
    private func generateLocation(for number: Int?) -> [NSNumber] {
        guard let number = number, number > 0, number < allowedSetColors.count else { return [] }
        
        var output: [NSNumber] = []
        let step: Float = 1 / Float(number - 1)
        var element: Float = 0
        
        for _ in 1 ... number {
            output.append(element as NSNumber)
            element += step
        }
        return output
    }
    
    
    func setRandomProperty() {
        let newColors = randomColors()
//        let newColors = randomAllowedColors(for: colors?.count ?? 2)
        let newLocation = generateLocation(for: newColors.count)
        let newDirection = GradientDirection(start: GradientScreenPoint(startPoint), end: GradientScreenPoint(endPoint)).new()
        
        colors = newColors
        locations = newLocation
        startPoint = newDirection.direction.start
        endPoint = newDirection.direction.end
    }
}

//
//  CAGradientLayer+Entitys.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 08.09.2023.
//

import UIKit

extension CAGradientLayer {
    
    var allowedSetColors: [UIColor] {
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
}

extension CAGradientLayer {
    
    /// Именнованные координаты некоторых точек пространства
    ///
    /// Координаты начинаюсть в левом верхнем углу точка (0, 0) и заканчиваються в правом нижнем углу с координатой (1, 1)
    /// Эта система координат используеться для задание начальной и конечной точки направления градиента точки startPoint  и endPoint
    ///
    /// Решая задачу анимирование градиента были вбраны некоторые опорные точки,
    /// от одной точке к другой будет меняться направление слоя градиента
    ///
    /// Координаты опорных точки:                   Именнованные значения опорных точки:
    ///     (0, 0)      (0.5, 0)    (1, 0)                              topLeft             top             topRight
    ///     (0, 0.5)                  (1, 0.5)                           left                                      right
    ///     (0, 1)      (0, 0.5)    (1, 1)                              bottomLeft      bottom        bottomRight
    ///
    enum GradientScreenPoint {
        
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
        
        //  Преобразует любой CGPoint в опорную точку по правилам округления
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
    
    
    /// Направления распростронения градиента
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
}

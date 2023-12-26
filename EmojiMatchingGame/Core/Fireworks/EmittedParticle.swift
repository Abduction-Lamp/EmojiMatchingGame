//
//  EmittedParticle.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 26.09.2023.
//

import UIKit

// MARK: - Emitted Particle
///
/// Частицы из которых состоит салют
///
/// Реализовано три типа частиц:
/// - shape - геометрические фигуры ( circle, square, triangle )
/// - image - изображение
/// - text - текст
///
/// У каждой частицы есть свой набор параметров, это позволяет разнообразить салют
///
/// - Parameters:
///     - size (font): Задает размер частицы, для частиц в текстовом представлении задаеться font, внутрений механизм вычислит область занимаемую текстом
///     - color: Цвет частицы, для текстового представления этот параметр опциональный, так как для эмоджи цвет можно не задавать
///     - birthRate: Частота рождения частиц в секунду, по умолчанию birthRate = 37
///
enum EmittedParticle {
    
    enum Shape {
        case circle
        case square
        case triangle
    }
    
    case shape(Shape,   size: CGSize,  color: UIColor,  birthRate: Float?)
    case image(UIImage, size: CGSize?, color: UIColor,  birthRate: Float?)
    case text (String,  font: UIFont,  color: UIColor?, birthRate: Float?)
}


extension EmittedParticle.Shape {
    
    private func path(in rect: CGRect) -> CGPath {
        switch self {
        case .circle:
            return CGPath(ellipseIn: rect, transform: nil)
        case .square:
            return CGPath(rect: rect, transform: nil)
        case .triangle:
            let triangle = CGMutablePath()
            triangle.addLines(between: [
                CGPoint(x: rect.minX, y: .zero),
                CGPoint(x: rect.maxX, y: rect.maxY),
                CGPoint(x: rect.minX, y: rect.maxY),
                CGPoint(x: rect.minX, y: .zero),
            ])
            return triangle
        }
    }
    
    fileprivate func image(size: CGSize, color: UIColor) -> UIImage {
        let rect = CGRect(origin: .zero, size: size)
        return UIGraphicsImageRenderer(size: size).image { context in
            context.cgContext.addPath(path(in: rect))
            context.cgContext.setFillColor(color.cgColor)
            context.cgContext.fillPath()
        }
    }
}


extension EmittedParticle {
    
    var image: UIImage {
        switch self {
        case let .shape(shape, size, color, _):
            return shape.image(size: size, color: color)
            
        case let .image(image, size, color, _):
            return image.withColor(color, size: size)

        case let .text(text, font, color, _):
            return makeImageFromText(text, font: font, color: color)
        }
    }
    
    var birthRate: Float? {
        switch self {
        case let .shape (_, _, _, birthRate): return birthRate
        case let .image (_, _, _, birthRate): return birthRate
        case let .text  (_, _, _, birthRate): return birthRate
        }
    }

    
    private func makeImageFromText(_ text: String, font: UIFont, color: UIColor?) -> UIImage {
        /// Получаем размер области занимаемую текстом
        let label = UILabel()
        label.font = font
        label.text = text
        let size = label.intrinsicContentSize
        
        var attributes: [NSAttributedString.Key : Any] = [ .font : font ]
        if let color = color { attributes[.foregroundColor] = color }
        
        return UIGraphicsImageRenderer(size: size).image { _ in
            NSAttributedString(string: "\(text)", attributes: attributes).draw(at: .zero)
        }
    }
}

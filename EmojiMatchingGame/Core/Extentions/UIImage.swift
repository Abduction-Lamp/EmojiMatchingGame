//
//  UIImage.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 26.09.2023.
//

import UIKit

extension UIImage {
    
    // Функция меняет цвет изображения (например, системных изображений)
    func withColor(_ color: UIColor, size new: CGSize?) -> UIImage {
        var contentSize: CGSize = size
        if let new = new { contentSize = new }
        UIGraphicsBeginImageContextWithOptions(contentSize, false, scale)
        
        guard let context = UIGraphicsGetCurrentContext() else { return self }
        color.setFill()
        context.translateBy(x: 0, y: contentSize.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.setBlendMode(.normal)

        guard let cgImage = cgImage else { return self }
        let rect =  CGRect(origin: .zero, size: contentSize)
        context.clip(to: rect, mask: cgImage)
        context.fill(rect)

        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else { return self }
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

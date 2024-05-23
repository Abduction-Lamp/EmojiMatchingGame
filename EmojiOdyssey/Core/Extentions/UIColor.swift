//
//  UIColor.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 19.10.2023.
//

import UIKit

extension UIColor {
    
    public var hex: String {
        var r: CGFloat = 0      // red component
        var g: CGFloat = 0      // green component
        var b: CGFloat = 0      // blue component

        getRed(&r, green: &g, blue: &b, alpha: nil)
        return String(format: "#%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
    }
    
    public var alpha: CGFloat {
        var a: CGFloat = 0      // alpha component
        getRed(nil, green: nil, blue: nil, alpha: &a)
        return a
    }
    

    public convenience init?(hex: String, alpha: CGFloat = 1.0) {
        var pure = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
       
        if pure.hasPrefix("#") {
            pure.remove(at: pure.startIndex)
        }
        guard pure.range(of: "^[0-9A-Fa-f]+$", options: .regularExpression) != nil else { return nil }
        
        var scan: UInt64 = 0
        if Scanner(string: pure).scanHexInt64(&scan) {
            let r, g, b, a: CGFloat     // red, green, blue and alpha components
            
            switch pure.count {
            case 3:
                r = CGFloat((scan >> 8) & 0xF) * 17 / 255
                g = CGFloat((scan >> 4) & 0xF) * 17 / 255
                b = CGFloat((scan >> 0) & 0xF) * 17 / 255
                a = (alpha >= 0 && alpha <= 1) ? alpha : 1.0
                
            case 6:
                r = CGFloat((scan >> 16) & 0xFF) / 255
                g = CGFloat((scan >> 8)  & 0xFF) / 255
                b = CGFloat((scan >> 0)  & 0xFF) / 255
                a = (alpha >= 0 && alpha <= 1) ? alpha : 1.0
                
            case 8:
                r = CGFloat((scan >> 24) & 0xFF) / 255
                g = CGFloat((scan >> 16) & 0xFF) / 255
                b = CGFloat((scan >> 8)  & 0xFF) / 255
                a = CGFloat((scan >> 0)  & 0xFF) / 255
                
            default: return nil
            }
            
            self.init(red: r, green: g, blue: b, alpha: a)
        } else { return nil }
    }
    
    
    public convenience init?(hex: Int, alpha: CGFloat = 1.0) {
        guard hex >= 0x000000, hex <= 0xFFFFFF else { return nil }
        
        let r: CGFloat = CGFloat((hex >> 16) & 0xFF)
        let g: CGFloat = CGFloat((hex >> 8) & 0xFF)
        let b: CGFloat = CGFloat(hex & 0xFF)
        let a: CGFloat = (alpha >= 0 && alpha <= 1) ? alpha : 1.0
        
        self.init(red: r/255, green: g/255, blue: b/255, alpha: a)
    }
}


extension UIColor {
    
    public enum Model {
        case rgb
        case hue
    }

    public static func random(_ model: UIColor.Model = .rgb) -> UIColor {
        switch model {
        case .rgb:
            let randomHex = Int.random(in: 0x000000 ... 0xFFFFFF)
            return UIColor(hex: randomHex) ?? .white
        case .hue:
            let hue: CGFloat = CGFloat.random(in: 0 ... 360)
            let saturation: CGFloat = CGFloat.random(in: 0.5 ... 1)
            let brightness: CGFloat = CGFloat.random(in: 0.7 ... 0.9)
            return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
        }
    }
    
    public static func randomSet(count: Int) -> [CGColor] {
        var set: [CGColor] = []
        
        let full = 0 ... 35
        let cropped = 2 ... 33
        let sign = (Int.random(in: 1 ... 2) % 2) == 0 ? 1 : -1
        
        let hue1 = Int.random(in: full)
        var hue2 = hue1 + sign * Int.random(in: cropped)
        
        switch hue2 {
        case (36 ... .max): hue2 = hue2 - 35
        case (.min ..< 0) : hue2 = hue2 + 35
        default: break
        }
        
        set.append(UIColor(hue: CGFloat(hue1)/100,
                           saturation: CGFloat.random(in: 0.5 ... 1),
                           brightness: CGFloat.random(in: 0.7 ... 0.9),
                           alpha: 1).cgColor)
        set.append(UIColor(hue: CGFloat(hue2)/100,
                           saturation: CGFloat.random(in: 0.5 ... 0.9),
                           brightness: CGFloat.random(in: 0.7 ... 0.9),
                           alpha: 1).cgColor)
        return set
    }
}

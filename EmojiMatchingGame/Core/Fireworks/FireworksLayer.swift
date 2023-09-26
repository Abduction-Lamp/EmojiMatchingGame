//
//  FireworksLayer.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 20.09.2023.
//

import UIKit

final class FireworksLayer: CAEmitterLayer {

    func configureDefault() {
        renderMode = .oldestFirst
        emitterMode = .outline
        emitterShape = .circle
        
        birthRate = 0
    }
    
    func configureDefault(with contents: [EmittedParticle] ) {
        configureDefault()
        particles(with: contents)
    }
    
    func layout(by bounds: CGRect) {
        frame = bounds
        let smallerSide = min(bounds.size.width, bounds.size.height)
        emitterSize = .init(width: smallerSide, height: smallerSide)
        emitterPosition = .init(x: bounds.midX, y: bounds.midY)
    }
    
    
    func particles(with contents: [EmittedParticle]) {
        emitterCells = contents.map { particle in
            let cell = CAEmitterCell()
            
            cell.birthRate = particle.birthRate ?? 37
            
            cell.lifetime = 1.0
            cell.lifetimeRange = 0.7
            
            cell.velocity = CGFloat(cell.birthRate * cell.lifetime) + 250
            cell.velocityRange = cell.velocity / 2

            cell.spin = .pi
            cell.spinRange = .pi
            
            cell.alphaRange = 0.9
            cell.alphaSpeed = 0.1
            
            cell.scaleRange = 0.5
            cell.scale = 1.0 - cell.scaleRange
            cell.scaleSpeed = 0.2
            
            cell.emissionLatitude = 1.1
            cell.emissionLongitude = 1.2
            
            cell.contents = particle.image.cgImage
            
            return cell
        }
    }

    func emit(duration: CFTimeInterval = 1) {
        beginTime = convertTime(CACurrentMediaTime(), to: nil)

        let animation = CAKeyframeAnimation(keyPath: #keyPath(CAEmitterLayer.birthRate))
        animation.duration = duration
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        animation.fillMode = .forwards
        animation.values = [1, 1, 0]
        animation.keyTimes = [0, 0.9, 1]
        animation.isRemovedOnCompletion = false
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            let transition = CATransition()
            transition.duration = self.lifetimeCell()
            transition.timingFunction = CAMediaTimingFunction(name: .easeOut)
            transition.type = .fade
            transition.isRemovedOnCompletion = false
            transition.setValue(self, forKey: "birthRateAnimation")
            transition.delegate = self
            self.add(transition, forKey: nil)
        }
        self.add(animation, forKey: nil)
        CATransaction.commit()
    }
    
    private func lifetimeCell() -> CFTimeInterval {
        var maxLifetimeCell = -(Float.infinity)
        emitterCells?.forEach { maxLifetimeCell = max($0.lifetime + $0.lifetimeRange, maxLifetimeCell) }
        maxLifetimeCell *= lifetime
        if maxLifetimeCell > 3 || maxLifetimeCell <= 0 { maxLifetimeCell = 3 }
        return CFTimeInterval(maxLifetimeCell)
    }
}


extension FireworksLayer: CAAnimationDelegate {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let layer = anim.value(forKey: "birthRateAnimation") as? FireworksLayer {
            layer.removeAllAnimations()
            layer.removeFromSuperlayer()
        }
    }
}

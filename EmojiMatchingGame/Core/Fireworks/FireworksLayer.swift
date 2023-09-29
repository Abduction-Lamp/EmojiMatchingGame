//
//  FireworksLayer.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 20.09.2023.
//

import UIKit

/// Салют - слой испускающий частицы
///
final class FireworksLayer: CAEmitterLayer {

    func сonfiguration() {
        renderMode = .oldestFirst
        emitterMode = .outline
        emitterShape = .circle
        
        // Параметр birthRate для слоя (CAEmitterLayer) умножаеться на такой же параметр но для каждой частицы (CAEmitterCell)
        //
        // Таким образаом:
        // - birthRate = 0   - то слой ничего не испускает
        // - birthRate = 0,5 - частиц испускаеться в два раза меньше
        // - birthRate = 1   - частицы испускаються согласно параметру birthRate определенного в CAEmitterCell
        birthRate = 0
    }
    
    func сonfiguration(with contents: [EmittedParticle] ) {
        сonfiguration()
        particles(with: contents)
    }
    
    func layout(by bounds: CGRect, center: CGPoint? = nil, radius: CGFloat? = nil) {
        frame = bounds
        
        var position = CGPoint(x: bounds.midX, y: bounds.midY)
        var size = CGSize.zero

        if let center = center { position = center }
        if let radius = radius {
            size = .init(width: radius, height: radius)
        } else {
            let smallerSide = min(bounds.size.width, bounds.size.height)
            size = .init(width: smallerSide, height: smallerSide)
        }
        
        emitterSize = size
        emitterPosition = position
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

    /** Функция испуска частиц  */
    
    /* Задача этой функции испускать частицы в течении заданного времяни (duration),
     * а так же дать дожить последней испущенной частицы, согласно ее времяни жизни (параметр lifetime в CAEmitterCell)
     *
     * Для решение этой задачи создадим атамарную операцию (транзакцию).
     * Это будет анимация изменяющая birthRate слоя (CAEmitterLayer) с 1 в 0, длительностью равной продолжительности испускания (салюта)
     * и CompletionBlock, который тоже анимация, но длительностью равной максимальной возможной длительности жизни одной частицы.
     *
     * Таким образом можем дождаться окончания солюта. */
    
    func emit(duration: CFTimeInterval = 1) {
        // Устанавливаем настоящий момент как время начало испускания частиц
        beginTime = CACurrentMediaTime()

        let animation = CAKeyframeAnimation(keyPath: #keyPath(CAEmitterLayer.birthRate))
        animation.duration = duration
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        animation.fillMode = .forwards
        animation.values    = [1, 1, 0.5, 0]    // birthRate CAEmitterLayer
        animation.keyTimes  = [0, 0.6, 0.9, 1]
        animation.isRemovedOnCompletion = false
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            let animationCompletionExpected = CABasicAnimation(keyPath: nil)
            animationCompletionExpected.duration = self.lifetimeCell()
            animationCompletionExpected.isRemovedOnCompletion = false
            animationCompletionExpected.setValue(self, forKey: "birthRateAnimation")
            animationCompletionExpected.delegate = self
            self.add(animationCompletionExpected, forKey: nil)
        }
        self.add(animation, forKey: nil)
        CATransaction.commit()
    }
    
    // Возвращает максимальное время жизни одной частицы
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
        }
    }
}

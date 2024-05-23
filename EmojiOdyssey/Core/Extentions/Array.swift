//
//  Array.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 17.04.2024.
//

import Foundation

extension Array {
    
    /// Алгоритм из коробки:
    /// - Перемешиваем исходный массив
    /// - Затем берем первые/последнии k елементов
    ///
    /// - Исходный массив остается неизменным
    ///
    /// - Complexity: O(n).
    /// Для k много меньше n предлогаю воспользоваться Алгоритм Тасование Фишера - Йетса
    /// shuffled(only k: Int) -> SubSequence, сложность которого O(k)
    ///
    func shuffled(prefix k: Int) -> SubSequence {
        self.shuffled().prefix(Swift.min(k, count))
    }
    
    func shuffled(suffix k: Int) -> SubSequence {
        self.shuffled().suffix(Swift.min(k, count))
    }
    
    
    /// Алгоритм Тасование Фишера - Йетса:
    ///
    /// Перемешивает только k элементов массива
    /// Исходный массив остается неизменным
    ///
    /// - Complexity: O(k)
    ///
    func shuffled(only k: Int) -> SubSequence {
        var stirrer = self
        let end = Swift.min(k, count)

        for step in 1 ... end {
            let last = count - step
            let index = Int.random(in: 0 ... last)
            stirrer.swapAt(index, last)
        }
        return stirrer.suffix(end)
    }
}

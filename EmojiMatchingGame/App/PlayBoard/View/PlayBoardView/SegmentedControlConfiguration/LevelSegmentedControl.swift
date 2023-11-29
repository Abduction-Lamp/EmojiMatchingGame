//
//  LevelSegmentedControl.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 09.11.2023.
//

import UIKit

protocol LevelSegmentedCustomizable where Self: UISegmentedControl {
    
    func shadow(isEnabled: Bool)
    func unlock(_ level: Indexable)
    func select(_ level: Indexable)
}


final class LevelSegmentedControl: UISegmentedControl {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    override init(items: [Any]?) {
        super.init(items: items)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("⚠️ \(Self.description()) init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
        
        let color: (normal: UIColor, selected: UIColor, disabled: UIColor) =
        (
            normal:   .systemGreen.withAlphaComponent(0.4),
            selected: .systemGreen,
            disabled: .systemGray.withAlphaComponent(0.4)
        )
        setTitleTextAttributes([.foregroundColor: color.selected], for: .selected)
        setTitleTextAttributes([.foregroundColor: color.normal],   for: .normal)
        setTitleTextAttributes([.foregroundColor: color.disabled], for: .disabled)
        

        
//        let image = UIImage(named: "TransparentBackground")
//        setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
//        setBackgroundImage(image, for: .selected, barMetrics: .default)
//        setBackgroundImage(UIImage(), for: .disabled, barMetrics: .default)
        
        setup()
        shadow(isEnabled: true)
    }
    
    private func setup() {
        Level.allCases.forEach { level in
            let index = level.index
            let lock = UIImage(systemName: "lock")?.applyingSymbolConfiguration(.init(font: Design.Typography.font(.title)))
            lock?.accessibilityLabel = "Level \(index + 1)"
            insertSegment(with: lock, at: index, animated: false)
            setEnabled(false, forSegmentAt: index)
        }
    }
}


extension LevelSegmentedControl: LevelSegmentedCustomizable {
    
    func shadow(isEnabled: Bool) {
        layer.masksToBounds = !isEnabled
        layer.shadowColor = UIColor.systemGray.cgColor
        layer.shadowOpacity = 0.7
        layer.shadowRadius = 5
        layer.shadowOffset = .zero
    }
    
    func unlock(_ level: Indexable) {
        (0...level.index).forEach { indexSegment in
            guard !isEnabledForSegment(at: indexSegment) else { return }
            let image = UIImage(systemName: "\(indexSegment + 1).circle")?.applyingSymbolConfiguration(.init(font: Design.Typography.font(.title)))
            image?.accessibilityLabel = "Level \(indexSegment + 1)"
            setImage(image, forSegmentAt: indexSegment)
            setEnabled(true, forSegmentAt: indexSegment)
        }
    }
    
    func select(_ level: Indexable) {
        if isEnabledForSegment(at: level.index) {
            selectedSegmentIndex = level.index
        }
    }
}

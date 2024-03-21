//
//  ThemeSegmentedControl.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 13.03.2024.
//

import UIKit

fileprivate protocol ItemSegmentable where Self: UIView {
    var isSelected: Bool { get set }
}

final fileprivate class RadioButtonSegmentedItem: UIView, ItemSegmentable {
    
    private let imageSelected: UIImage? = {
        var img = UIImage(systemName: "checkmark.circle.fill")
        img = img?.applyingSymbolConfiguration(.init(paletteColors: [.systemGreen]))
        img = img?.applyingSymbolConfiguration(.init(weight: .bold))
        return img
    }()
    
    private let imageNotSelected: UIImage? = {
        var img = UIImage(systemName: "circle")
        img = img?.applyingSymbolConfiguration(.init(paletteColors: [.systemGray4]))
        img = img?.applyingSymbolConfiguration(.init(weight: .thin))
        return img
    }()
    
    var isSelected: Bool = false {
        didSet {
            if isSelected {
                backgroundColor = .systemGray.withAlphaComponent(0.17)
                checkImageView.image = imageSelected
                contentImage.preferredSymbolConfiguration = .init(paletteColors: [.systemBlue])
                contentLabel.font = .systemFont(ofSize: UIFont.labelFontSize, weight: .bold)
            } else {
                backgroundColor = .clear
                checkImageView.image = imageNotSelected
                contentImage.preferredSymbolConfiguration = .init(paletteColors: [.systemGray4])
                contentLabel.font = .systemFont(ofSize: UIFont.labelFontSize, weight: .light)
            }
        }
    }
    
    private lazy var checkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = imageNotSelected
        return imageView
    }()
    
    private var contentImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.preferredSymbolConfiguration = .init(paletteColors: [.systemGray4])
        return imageView
    }()
    
    private var contentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    
    init(title: String, image: UIImage?) {
        super.init(frame: .zero)
        
        contentImage.image = image?.applyingSymbolConfiguration(.init(weight: .thin))
        contentLabel.text = title
        configure()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("⚠️ \(Self.description()) init(coder:) has not been implemented")
    }
    
    private func configure() {
        layer.masksToBounds = true
        layer.cornerRadius = 12
        
        addSubview(checkImageView)
        addSubview(contentImage)
        addSubview(contentLabel)
        
        NSLayoutConstraint.activate([
            checkImageView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            checkImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            checkImageView.widthAnchor.constraint(equalToConstant: 30),
            checkImageView.heightAnchor.constraint(equalToConstant: 30),
            
            contentImage.topAnchor.constraint(equalTo: checkImageView.bottomAnchor, constant: 2 * directionalLayoutMargins.top),
            contentImage.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            contentImage.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            contentImage.bottomAnchor.constraint(equalTo: contentLabel.topAnchor, constant: -directionalLayoutMargins.top),

            contentLabel.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
            contentLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}



final class ThemeSegmentedControl: UIControl {

    private var items: [ItemSegmentable] = []
    
    var numberOfSegments: Int {
        items.count
    }
    
    var selectedSegmentIndex: Int = -1 {
        willSet {
            if (selectedSegmentIndex >= 0) && (selectedSegmentIndex < items.count) {
                items[selectedSegmentIndex].isSelected = false
            }
            if (newValue >= 0) && (newValue < items.count) {
                items[newValue].isSelected = true
            }
        }
    }
    
    private var stack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        return stackView
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("⚠️ \(Self.description()) init(coder:) has not been implemented")
    }
    
    func addItem(title: String, image: UIImage?) {
        let item = RadioButtonSegmentedItem(title: title, image: image)
        
        items.append(item)
        stack.addArrangedSubview(item)
    }
    
    func removeItem(at index: Int) {
        let item = items.remove(at: index)
        stack.removeArrangedSubview(item)
    }
}


extension ThemeSegmentedControl {
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        for item in items {
            if item.frame.contains(point) {
                return self
            }
        }
        return super.hitTest(point, with: event)
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for item in items {
            if item.frame.contains(point) {
                return true
            }
        }
        return super.point(inside: point, with: event)
    }
    
    
    override func endTracking(_ touch: UITouch?, with: UIEvent?) {
        defer { super.endTracking(touch, with: with) }
        
        if let location = touch?.location(in: self) {
            for (index, item) in items.enumerated() {
                if item.frame.contains(location), item.isSelected == false {
                    selectedSegmentIndex = index
                    sendActions(for: .valueChanged)
                    return
                }
            }
        }
    }
}

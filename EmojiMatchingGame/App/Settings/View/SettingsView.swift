//
//  SettingsView.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 24.10.2023.
//

import UIKit

final class SettingsView: UIView {
    
    private let blur: UIVisualEffectView = {
        let blur = UIVisualEffectView()
        blur.effect = UIBlurEffect(style: .systemThickMaterial)
        blur.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return blur
    }()
    
    private let title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = Design.Typography.font(.title)
        label.textAlignment = .center
        label.text = String(localized: "Settings")
        return label
    }()
    
    private let stack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = Design.Padding.item.spacing
        return stack
    }()
    
    // Стандартная ширина UISwitch, этот размер будет использоваться для размера trailing элемента в SlotView
    // Так как UISwitch в текущем дизайне самый широкий элемент из элементов размещенных в trailing
    // Что позволяет нам сделать все элементы в trailing одинакового размера
    private let width = UISwitch().bounds.width
    
    private lazy var colorSlotView = SlotView(
        body: {
            let label = UILabel()
            label.font = Design.Typography.font(.item)
            label.adjustsFontForContentSizeCategory = true
            label.text = String(localized: "Settings.Color")
            return label
        }(),
        trailing: {
            let button = UIButton(configuration: .filled())
            button.widthAnchor.constraint(equalToConstant: width).isActive = true
            button.heightAnchor.constraint(equalToConstant: width).isActive = true
            button.addTarget(self, action: #selector(colorButtonTapped(_:)), for: .touchUpInside)
            return button
        }()
    )
    
    private lazy var animationSlotView = SlotView(
        body: {
            let label = UILabel()
            label.font = Design.Typography.font(.item)
            label.adjustsFontForContentSizeCategory = true
            label.text = String(localized: "Settings.Animation")
            return label
        }(),
        trailing: {
            let toggle = UISwitch()
            toggle.addTarget(self, action: #selector(animationToggleSwitched(_:)), for: .touchUpInside)
            return toggle
        }()
    )
    
    private lazy var soundSlotView = SlotView(
        body: {
            let label = UILabel()
            label.font = Design.Typography.font(.item)
            label.adjustsFontForContentSizeCategory = true
            label.text = String(localized: "Settings.Sound")
            return label
        }(),
        trailing: {
            let size = Design.Typography.font(.title).height
            let imgge = UIImage(systemName: "speaker.wave.3.fill")
            let imageView = UIImageView()
            imageView.image = imgge
            imageView.contentMode = .scaleAspectFill
            imageView.widthAnchor.constraint(equalToConstant: size).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: size).isActive = true
            return imageView
        }()
    )
    
    private lazy var soundVolumeSlider = UISlider()
    
    private lazy var reset: UIButton = {
        let button = UIButton(configuration: .plain())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(resetTapped(_:)), for: .touchUpInside)
        button.configuration?.title = String(localized: "Reset")
        return button
    }()
    
    
    // MARK: SettingsView Delegate
    weak var delegate: SettingsViewDelegate?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        print("\tVIEW\t😈\tSettings")
    }
    
    required init?(coder: NSCoder) {
        fatalError("⚠️ \(Self.description()) init(coder:) has not been implemented")
    }
    
    deinit {
        print("\tVIEW\t♻️\tSettings")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        blur.frame = bounds
    }
    
    
    private func configure() {
        addSubview(blur)
        addSubview(title)
        addSubview(stack)
        addSubview(reset)
        
        stack.addArrangedSubview(colorSlotView)
        stack.addArrangedSubview(animationSlotView)
        stack.addArrangedSubview(soundSlotView)
        stack.addArrangedSubview(soundVolumeSlider)
        
        let padding = Design.Padding.title.spacing
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: padding),
            title.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            
            stack.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: padding),
            stack.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            
            reset.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            reset.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -padding)
        ])
    }
}


extension SettingsView: SettingsViewSetupable {
    
    func setupColor(_ color: UIColor) -> Bool {
        guard let control = colorSlotView.trailing as? UIButton else { return false }
        control.configuration?.baseBackgroundColor = color
        return true
    }
    
    func setupAnimation(_ isAnimation: Bool) -> Bool {
        guard let control = animationSlotView.trailing as? UISwitch else { return false }
        control.setOn(isAnimation, animated: false)
        return true
    }
    
    func setupSoundVolume(_ value: Float) -> Bool {
        guard soundSlotView.trailing is UIImageView else { return false }
        soundVolumeSlider.value = value
        return true
    }
}


extension SettingsView {
    
    @objc
    private func colorButtonTapped(_ sender: UIButton) {
        self.delegate?.colorButtonTapped(sender)
    }
    
    @objc
    private func animationToggleSwitched(_ sender: UISwitch) {
        delegate?.animationToggleSwitched(sender.isOn)
    }
    
    @objc
    private func resetTapped(_ sender: UIButton) {
        delegate?.resetTapped()
    }
}

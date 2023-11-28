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
        label.font = Design.Typography.title.font
        label.textAlignment = .center
        label.text = "Настройки"
        return label
    }()
    
    private let stack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = Design.Padding.item.spacing
        return stack
    }()
    
    private lazy var colorSlotView = SlotView(
        body: {
            let label = UILabel()
            label.font = Design.Typography.item.font
            label.adjustsFontForContentSizeCategory = true
            label.text = "Цвет рубашки"
            return label
        }(),
        trailing: {
            let size = Design.Typography.item.font.height
            let control = UIColorWell()
            control.title = "Цвет рубашки"
            control.supportsAlpha = false
            control.widthAnchor.constraint(equalToConstant: size).isActive = true
            control.heightAnchor.constraint(equalToConstant: size).isActive = true
            control.addAction(colorWellAction, for: .valueChanged)
            return control
        }()
    )
    
    private lazy var colorWellAction = UIAction { action in
        guard let control = action.sender as? UIColorWell,
              let selectedColor = control.selectedColor
        else { return }
        self.delegate?.colorDidChanged(selectedColor)
    }
    
    private lazy var animationSlotView = SlotView(
        body: {
            let label = UILabel()
            label.font = Design.Typography.item.font
            label.adjustsFontForContentSizeCategory = true
            label.text = "Анимация"
            return label
        }(),
        trailing: {
            let toggle = UISwitch()
            toggle.addTarget(self, action: #selector(animationToggleSwitched(_:)), for: .touchUpInside)
            return toggle
        }()
    )
    
    private lazy var hapticSlotView = SlotView(
        body: {
            let label = UILabel()
            label.font = Design.Typography.item.font
            label.adjustsFontForContentSizeCategory = true
            label.text = "Тактильная обратная связь"
            return label
        }(),
        trailing: {
            let toggle = UISwitch()
            toggle.addTarget(self, action: #selector(hapticToggleSwitched(_:)), for: .touchUpInside)
            return toggle
        }()
    )
    
    private lazy var soundSlotView = SlotView(
        body: {
            let label = UILabel()
            label.font = Design.Typography.item.font
            label.adjustsFontForContentSizeCategory = true
            label.text = "Громкость звука"
            return label
        }(),
        trailing: {
            let size = Design.Typography.item.font.height
            let imageView = UIImageView()
            imageView.image = UIImage(systemName: "speaker.wave.3.fill")
            imageView.contentMode = .scaleAspectFill
            imageView.widthAnchor.constraint(equalToConstant: size).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: size).isActive = true
            return imageView
        }()
    )
    
    private lazy var soundVolumeSlider = UISlider()
    
    private let reset: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = "Сброс"
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var resetCenterXAnchor: NSLayoutConstraint = .init()
    
    
    
    // MARK: SettingsView Delegate
    weak var delegate: SettingsViewDelegate?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        print("\tVIEW:\t😈\tSettings")
    }
    
    required init?(coder: NSCoder) {
        fatalError("⚠️ \(Self.description()) init(coder:) has not been implemented")
    }
    
    deinit {
        print("\tVIEW:\t♻️\tSettings")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        blur.frame = bounds
        resetCenterXAnchor.constant = bounds.width/3
    }
    
    
    private func configure() {
        addSubview(blur)
        addSubview(title)
        addSubview(stack)
        addSubview(reset)
        
        stack.addArrangedSubview(colorSlotView)
        stack.addArrangedSubview(animationSlotView)
        stack.addArrangedSubview(hapticSlotView)
        stack.addArrangedSubview(soundSlotView)
        stack.addArrangedSubview(soundVolumeSlider)
        
        let padding = Design.Padding.title.spacing
        resetCenterXAnchor = reset.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor, constant: 0)
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: padding),
            title.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            
            stack.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: padding),
            stack.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            
//            reset.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            resetCenterXAnchor,
            reset.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -padding)
        ])
        
        reset.addTarget(self, action: #selector(resetTapped(_:)), for: .touchUpInside)
    }
}


extension SettingsView: SettingsViewSetupable {
    
    func setupColor(_ color: UIColor) -> Bool {
        guard let control = colorSlotView.trailing as? UIColorWell else { return false }
        control.selectedColor = color
        return true
    }
    
    func setupAnimation(_ isAnimation: Bool) -> Bool {
        guard let control = animationSlotView.trailing as? UISwitch else { return false }
        control.setOn(isAnimation, animated: false)
        return true
    }
    
    func setupHaptic(_ isHaptic: Bool) -> Bool {
        guard let control = hapticSlotView.trailing as? UISwitch else { return false }
        control.setOn(isHaptic, animated: false)
        return true
    }
    
    func setupHapticEnabled(_ isEnabled: Bool) -> Bool {
        guard 
            let label = hapticSlotView.body as? UILabel,
            let control = hapticSlotView.trailing as? UISwitch
        else { return false }
        label.isEnabled = isEnabled
        control.isEnabled = isEnabled
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
    private func animationToggleSwitched(_ sender: UISwitch) {
        delegate?.animationToggleSwitched(sender.isOn)
    }
    
    @objc
    private func hapticToggleSwitched(_ sender: UISwitch) {
        delegate?.hapticToggleSwitched(sender.isOn)
    }
    
    @objc
    private func resetTapped(_ sender: UIButton) {
        delegate?.resetTapped()
    }
}

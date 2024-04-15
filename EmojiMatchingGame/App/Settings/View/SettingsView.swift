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
            let toggle = UISwitch()
            toggle.addTarget(self, action: #selector(soundToggleSwitched(_:)), for: .touchUpInside)
            return toggle
        }()
    )
    
    private var soundVolumeSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.isContinuous = false
        return slider
    }()
    
    private let themeSegmentedControl = ThemeSegmentedControl()
    
    private var reset: UIButton = {
        let button = UIButton(configuration: .plain())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration?.title = String(localized: "Reset")
        return button
    }()
    
    
    // MARK: SettingsView Delegate
    weak var delegate: SettingsViewDelegate?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("⚠️ \(Self.description()) init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        blur.frame = bounds
    }
    
    
    private func configure() {
        addSubview(blur)
        addSubview(title)
        addSubview(themeSegmentedControl)
        addSubview(stack)
        addSubview(reset)
        
        stack.addArrangedSubview(colorSlotView)
        stack.addArrangedSubview(animationSlotView)
        stack.addArrangedSubview(soundSlotView)
        stack.addArrangedSubview(soundVolumeSlider)
        
        themeSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        themeSegmentedControl.addItem(title: String(localized: "Settings.Theme.Light"),  image: .init(systemName: "sun.max.circle.fill"))
        themeSegmentedControl.addItem(title: String(localized: "Settings.Theme.Dark"),   image: .init(systemName: "moon.circle.fill"))
        themeSegmentedControl.addItem(title: String(localized: "Settings.Theme.System"), image: .init(systemName: "circle.lefthalf.filled"))
        
        
        let padding = Design.Padding.title.spacing
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: padding),
            title.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            
            themeSegmentedControl.topAnchor.constraint(equalTo: title.bottomAnchor, constant: padding),
            themeSegmentedControl.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            themeSegmentedControl.widthAnchor.constraint(equalToConstant: 350),
            themeSegmentedControl.heightAnchor.constraint(equalToConstant: 150),
            
            stack.topAnchor.constraint(equalTo: themeSegmentedControl.bottomAnchor, constant: padding),
            stack.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: padding),
            stack.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            stack.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            
            reset.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            reset.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -padding)
        ])
        
        themeSegmentedControl.addTarget(self, action: #selector(themeSegmentedChanged(_:)), for: .valueChanged)
        soundVolumeSlider.addTarget(self, action: #selector(volumeSlidercChanged), for: .valueChanged)
        reset.addTarget(self, action: #selector(resetTapped(_:)), for: .touchUpInside)
    }
}


extension SettingsView: SettingsViewSetupable {
    
    func setupTheme(_ mode: Int) -> Bool {
        guard (0...2).contains(mode) else { return false }
        themeSegmentedControl.selectedSegmentIndex = mode
        return true
    }
    
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
    
    func setupSoundVolume(_ isOn: Bool, volume: Float) -> Bool {
        guard let control = soundSlotView.trailing as? UISwitch else { return false }
        control.setOn(isOn, animated: false)
        if isOn {
            soundVolumeSlider.isHidden = false
            soundVolumeSlider.value = (0.0 ... 1.0).contains(volume) ? volume : 1.0
        } else {
            soundVolumeSlider.isHidden = true
            soundVolumeSlider.value = (0.0 ... 1.0).contains(volume) ? volume : 0.0
        }
        return true
    }
}


extension SettingsView {
    
    @objc
    private func themeSegmentedChanged(_ sender: ThemeSegmentedControl) {
        delegate?.themeChangedValue(sender.selectedSegmentIndex)
    }
    
    @objc
    private func colorButtonTapped(_ sender: UIButton) {
        self.delegate?.colorButtonTapped(sender)
    }
    
    @objc
    private func animationToggleSwitched(_ sender: UISwitch) {
        delegate?.animationToggleSwitched(sender.isOn)
    }
    
    @objc
    private func soundToggleSwitched(_ sender: UISwitch) {
        delegate?.soundToggleSwitched(sender.isOn)
    }
    
    @objc
    private func volumeSlidercChanged(_ sender: UISlider) {
        delegate?.volumeSliderChanged(sender.value)
    }
    
    @objc
    private func resetTapped(_ sender: UIButton) {
        delegate?.resetTapped()
    }
}

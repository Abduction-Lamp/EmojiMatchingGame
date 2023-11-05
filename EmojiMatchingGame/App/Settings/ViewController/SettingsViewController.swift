//
//  SettingsViewController.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 24.10.2023.
//

import UIKit

final class SettingsViewController: UIViewController {

    private var settingsView: UIView & SettingsViewSetupable {
        guard let view = self.view as? SettingsView else {
            return SettingsView(frame: self.view.frame)
        }
        return view
    }
    
    var presenter: SettingsPresentable?

    override func loadView() {
        print("VC:\t\t\t😈\tSettings (loadView)")
        view = SettingsView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        settingsView.delegate = self
        presenter?.fetch()
    }
        
    deinit {
        print("VC:\t\t\t♻️\tSettings ")
    }
}


extension SettingsViewController: SettingsDisplayable {
    
    func displayColor(_ color: UIColor) {
        let _ = settingsView.setupColor(color)
    }
    
    func displayAnimation(_ isAnimation: Bool) {
        let _ = settingsView.setupAnimation(isAnimation)
    }
    
    func displayHaptics(_ isHaptic: Bool) {
        let _ = settingsView.setupHaptic(isHaptic)
    }
    
    func displayHapticsSupports(_ isSupports: Bool) {
        let _ = settingsView.setupHapticEnabled(isSupports)
    }

    func displaySoundVolume(_ value: Float) {
        let _ = settingsView.setupSoundVolume(value)
    }
}


extension SettingsViewController: SettingsViewDelegate {
    
    func animationToggleSwitched(_ isOn: Bool) {
        presenter?.update(isAnimation: isOn)
    }
    
    func hapticToggleSwitched(_ isOn: Bool) {
        presenter?.update(isHaptics: isOn)
    }
    
    func colorDidChanged(_ new: UIColor) {
        presenter?.update(color: new)
    }
}

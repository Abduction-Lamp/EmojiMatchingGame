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
    
    func colorButtonTapped(_ sender: UIButton) {
        guard let current = sender.configuration?.baseBackgroundColor else { return }
        
        let colorPicker = UIColorPickerViewController()
        colorPicker.modalPresentationStyle = .automatic
        colorPicker.title = "Цвет рубашки"
        colorPicker.selectedColor = current
        colorPicker.supportsAlpha = false
        colorPicker.delegate = self
        
        present(colorPicker, animated: true)
    }
    
    func resetTapped() {
        let titleAlertController = NSLocalizedString("Вы действительно хотити сбросить все настройки игры?", comment: "Titel")
        let cancelAlertTitleButton = NSLocalizedString("Отмена", comment: "Cancel")
        let resetAlertTitleButton = NSLocalizedString("Сбросить найстройки", comment: "Delete")
        
        let alert = UIAlertController(title: titleAlertController, message: nil, preferredStyle: .alert)
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = settingsView
            popoverController.sourceRect = CGRect(origin: settingsView.center, size: .zero)
            popoverController.permittedArrowDirections = []
        }
        
        let cancelAction = UIAlertAction(title: cancelAlertTitleButton, style: .cancel, handler: nil)
        let resetAction = UIAlertAction(title: resetAlertTitleButton, style: .destructive) { _ in
            self.presenter?.reset()
        }
        alert.addAction(cancelAction)
        alert.addAction(resetAction)
        
        present(alert, animated: true, completion: nil)
    }
}


extension SettingsViewController: UIColorPickerViewControllerDelegate {
    
    func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
        guard !continuously else { return }
        print(color)
        presenter?.update(color: color)
    }

//    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) { }
}

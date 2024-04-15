//
//  ResultsViewController.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 23.11.2023.
//

import UIKit

final class ResultsViewController: UIViewController {
    
    private var resultsView: UIView & ResultsViewSetupable {
        guard let view = self.view as? (UIView & ResultsViewSetupable) else {
            return ResultsView()
        }
        return view
    }
    
    var presenter: ResultsPresentable?
    
    
    override func loadView() {
        view = ResultsView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultsView.resetAddTarget(self, action: #selector(resetTapped(_:)), for: .touchUpInside)
        
        // Titel Tabel Best Results
        resultsView.setup(level: nil, time: "⏱️", taps: "👇", font: Design.Typography.font(.title))
        presenter?.fetch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.soundGenerationToViewWillAppear()
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        presenter?.soundGenerationToDismiss()
    }
}


extension ResultsViewController: ResultsDisplayable {

    func display(level: String?, isLock: Bool, time: String?, taps: String?) {
        var image: UIImage?
        if var name = level {
            var color: UIColor = .systemGreen
            if (time == nil) || (taps == nil) {
                color = .systemGray2
                name = isLock ? "lock" : name
            }
            image = UIImage(systemName: "\(name).circle")
            image = image?.applyingSymbolConfiguration(.init(font: Design.Typography.font(.title)))
            image = image?.withColor(color, size: nil)
            image?.accessibilityLabel = "Level \(name)"
        }
        resultsView.setup(level: image, time: time, taps: taps)
    }
    
    @objc
    private func resetTapped(_ sender: UIButton) {
        let title = String(localized: "Alert.Results.Reset.Title")
        let cancel = String(localized: "Alert.Cancel")
        let delete = String(localized: "Alert.Settings.Reset")
        
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: cancel, style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: delete, style: .destructive, handler: { [weak self] _ in
            guard let self = self else { return }
            self.resultsView.clean()
            self.presenter?.reset()
        }))
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = resultsView
            popoverController.sourceRect = CGRect(origin: resultsView.center, size: .zero)
            popoverController.permittedArrowDirections = []
        }
        
        present(alert, animated: true, completion: nil)
    }
}

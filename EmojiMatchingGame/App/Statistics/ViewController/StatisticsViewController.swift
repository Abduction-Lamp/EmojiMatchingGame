//
//  StatisticsViewController.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 23.11.2023.
//

import UIKit

final class StatisticsViewController: UIViewController {
    
    private var statisticsView: UIView & StatisticsViewSetupable {
        guard let view = self.view as? (UIView & StatisticsViewSetupable) else {
            return StatisticsView()
        }
        return view
    }
    
    var presenter: StatisticsPresentable?
    
    
    override func loadView() {
        print("VC:\t\t\t😈\tStatistics (loadView)")
        view = StatisticsView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statisticsView.resetAddTarget(self, action: #selector(resetTapped(_:)), for: .touchUpInside)
        
        // Titel Tabel Best Results
        statisticsView.setup(level: nil, time: "⏱️", taps: "👇", font: Design.Typography.title.font)
        presenter?.fetch()
    }
    
    deinit {
        print("VC:\t\t\t♻️\tStatistics ")
    }
}


extension StatisticsViewController: StatisticsDisplayable {

    func setup(level: String?, isLock: Bool, time: String?, taps: String?) {
        var image: UIImage?
        if var name = level {
            var color: UIColor = .systemGreen
            if (time == nil) || (taps == nil) {
                color = .systemGray2
                name = isLock ? "lock" : name
            }
            image = UIImage(systemName: "\(name).circle")
            image = image?.applyingSymbolConfiguration(.init(font: Design.Typography.title.font))
            image = image?.withColor(color, size: nil)
            image?.accessibilityLabel = "Level \(name)"
        }
        statisticsView.setup(level: image, time: time, taps: taps)
    }
    
    @objc
    private func resetTapped(_ sender: UIButton) {
        let title = NSLocalizedString("Вы действительно хотити сбросить все результаты игры?", comment: "Titel")
        let cancel = NSLocalizedString("Отмена", comment: "Cancel")
        let delete = NSLocalizedString("Удалить результаты", comment: "Delete")
        
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: cancel, style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: delete, style: .destructive, handler: { [weak self] _ in
            guard let self = self else { return }
            self.statisticsView.clean()
            self.presenter?.reset()
        }))
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = statisticsView
            popoverController.sourceRect = CGRect(origin: statisticsView.center, size: .zero)
            popoverController.permittedArrowDirections = []
        }
        
        present(alert, animated: true, completion: nil)
    }
}

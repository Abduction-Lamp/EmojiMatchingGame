//
//  PlayBoardView.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 05.07.2023.
//

import UIKit

final class PlayBoardView: UIView {
    
    private lazy var board: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = max(max(layoutMargins.left, layoutMargins.right), max(layoutMargins.top, layoutMargins.bottom))
        return stack
    }()
    
    private var cells: [UIButton] = []
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configuration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("⚠️ PlayBoardView init(coder:) has not been implemented")
    }
    
    
    
    private func configuration() {
        backgroundColor = .systemYellow
        
        addSubview(board)
        
        let margins: CGFloat = max(max(layoutMargins.left, layoutMargins.right), max(layoutMargins.top, layoutMargins.bottom))
        let width: CGFloat = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height) - margins
        
        
        NSLayoutConstraint.activate([
            board.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            board.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            board.widthAnchor.constraint(equalToConstant: width),
            board.heightAnchor.constraint(equalToConstant: width)
        ])
        
        make()
    }
    
    private func make() {
        remove()
        
        for _ in 0 ..< 10 {
            let row = UIStackView()
            row.translatesAutoresizingMaskIntoConstraints = false
            row.axis = .horizontal
            row.distribution = .fillEqually
            row.spacing = board.spacing
            
            for _ in 0 ..< 10 {
                let cell = UIButton()
                cell.backgroundColor = .systemRed
                cell.layer.cornerRadius = 5
                
                cells.append(cell)
                row.addArrangedSubview(cell)
            }
            
            board.addArrangedSubview(row)
        }
    }
    
    private func remove() {
        board.arrangedSubviews.forEach { view in
            board.removeArrangedSubview(view)
        }
        cells.removeAll()
    }
}

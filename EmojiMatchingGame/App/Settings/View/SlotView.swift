//
//  SlotView.swift
//  EmojiMatchingGame
//
//  Created by Vladimir Lesnykh on 31.10.2023.
//

import UIKit

final class SlotView: UIView {

    let leading:  UIView?
    let body:     UIView
    let trailing: UIView?

    init(leading: UIView? = nil, body: UIView, trailing: UIView? = nil) {
        self.leading = leading
        self.body = body
        self.trailing = trailing
    
        super.init(frame: .zero)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("⚠️ \(Self.description()) init(coder:) has not been implemented")
    }
    
    private func configure() {
        backgroundColor = .clear
        addViews()
        configureLeading()
        configureBody()
        configureTrailing()
    }
    
    private func addViews() {
        if let leadingView = leading { addSubview(leadingView) }
        addSubview(body)
        if let trailingView = trailing { addSubview(trailingView) }
    }
    
    private func configureLeading() {
        guard let leading = self.leading else { return }
        leading.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leading.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            leading.trailingAnchor.constraint(equalTo: body.leadingAnchor),
            leading.centerYAnchor.constraint(equalTo: body.centerYAnchor)
        ])
        leading.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    private func configureBody() {
        body.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            body.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            body.leadingAnchor.constraint(equalTo: leading?.trailingAnchor ?? safeAreaLayoutGuide.leadingAnchor),
            body.trailingAnchor.constraint(equalTo: trailing?.leadingAnchor ?? safeAreaLayoutGuide.trailingAnchor),
            body.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
        body.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
    }
    
    private func configureTrailing() {
        guard let trailing = self.trailing else { return }
        trailing.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            trailing.leadingAnchor.constraint(equalTo: body.trailingAnchor),
            trailing.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            trailing.centerYAnchor.constraint(equalTo: body.centerYAnchor)
        ])
        trailing.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
}

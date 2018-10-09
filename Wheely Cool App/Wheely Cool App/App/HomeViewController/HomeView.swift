//
//  HomeView.swift
//  Wheely Cool App
//
//  Created by Guilherme Politta on 10/10/18.
//  Copyright © 2018 Guilherme Politta. All rights reserved.
//

import UIKit

private extension String {
    static let title = NSLocalizedString("Enter the options", comment: "Home Screen title")
    static let startButtonTitle = NSLocalizedString("Start", comment: "Start button title")
    static let addOptionButtonTitle = NSLocalizedString("Add option", comment: "Add option button title")
}

class HomeView: UIView {

    enum Sizing {
        static let floatingHeaderViewHeight: CGFloat = 44
        static let horizontalPadding: CGFloat = 20
        static let headerViewSize: CGSize = CGSize(width: UIScreen.main.bounds.width, height: 55)
        static let startButtonHeight: CGFloat = 52
        static let insets: UIEdgeInsets = UIEdgeInsets(x: horizontalPadding)
    }

    // MARK: - Inits

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(tableView)
        addSubview(floatingHeaderView)
        addSubview(startButton)

        floatingHeaderView.addTrailingView(addOptionButton, padding: .medium)

        tableView.tableHeaderView = headerView

        NSLayoutConstraint.activate([
            floatingHeaderView.boxAnchor.constraints(equalTo: boxAnchor, edgeAnchors: .allExceptBottom),
            floatingHeaderView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor,
                                                       constant: Sizing.floatingHeaderViewHeight),

            tableView.topAnchor.constraint(equalTo: floatingHeaderView.bottomAnchor),
            tableView.boxAnchor.constraints(equalTo: boxAnchor, edgeAnchors: .allExceptTop),

            startButton.heightAnchor.constraint(equalToConstant: Sizing.startButtonHeight),
            startButton.boxAnchor.constraints(equalTo: safeAreaLayoutGuide.boxAnchor, edgeAnchors: .allExceptTop,
                                              insets: Sizing.insets)
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Subviews

    private lazy var headerView: UIView = {
        let result = UIView(size: Sizing.headerViewSize)
        result.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.boxAnchor.constraints(equalTo: result.boxAnchor,
                                             edgeAnchors: .allExceptTrailing, insets: Sizing.insets)
        ])
        return result
    }()

    let titleLabel: UILabel = {
        let result = UILabel()
        result.text = .title
        result.textColor = .darkText
        result.font = .boldSystemFont(ofSize: 32)
        result.translatesAutoresizingMaskIntoConstraints = false
        return result
    }()

    let addOptionButton: UIButton = {
        let result = UIButton()
        result.setTitle(.addOptionButtonTitle, for: .normal)
        result.setTitleColor(.darkText, for: .normal)
        result.translatesAutoresizingMaskIntoConstraints = false
        return result
    }()

    lazy private (set) var floatingHeaderView: FloatingHeaderView = {
        let result = FloatingHeaderView(bigTitleHeight: headerView.height)
        result.title = .title
        return result
    }()

    let tableView: UITableView = {
        let result = UITableView()
        result.rowHeight = 44
        result.translatesAutoresizingMaskIntoConstraints = false
        result.tableFooterView = UIView(frame: .zero)
        return result
    }()

    let startButton: UIButton = {
        let result = UIButton()
        result.setTitle(.startButtonTitle, for: .normal)
        result.setTitleColor(.darkText, for: .normal)
        result.backgroundColor = .white
        result.layer.cornerRadius = 10
        result.layer.borderWidth = 1
        result.layer.borderColor = UIColor.black.cgColor
        result.translatesAutoresizingMaskIntoConstraints = false
        return result
    }()
}

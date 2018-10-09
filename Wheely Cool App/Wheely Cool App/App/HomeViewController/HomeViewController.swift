//
//  HomeViewController.swift
//  Wheely Cool App
//
//  Created by Guilherme Politta on 10/10/18.
//  Copyright © 2018 Guilherme Politta. All rights reserved.
//

import UIKit

private extension String {
    static let deleteTitle = NSLocalizedString("Delete", comment: "Delete option title")
}

class HomeViewController: UIViewController {

    // MARK: - Variables and Constants

    private let homeView: HomeView = HomeView()

    private var floatingHeaderView: FloatingHeaderView {
        return homeView.floatingHeaderView
    }

    private var titleLabel: UILabel {
        return homeView.titleLabel
    }

    private var options: [String] = ["Option 1", "Option 2", "Option 3", "Option 4"]

    // MARK: - View Lifecycle

    override func loadView() {
        view = homeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let tableView = homeView.tableView
        let startButton = homeView.startButton
        tableView.contentInset = UIEdgeInsets(bottom: view.safeAreaInsets.bottom + startButton.height)
        tableView.delegate = self
        tableView.dataSource = self

        tableView.registerCell(UITableViewCell.self)
    }
}

// MARK: - UITableViewDelegate

extension HomeViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        floatingHeaderView.scrollViewDidScroll(scrollView)

        let normalizedScrollPosition: CGFloat = scrollView.getNormalizedScrollPosition(titleLabel.height)
        titleLabel.alpha = normalizedScrollPosition
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        floatingHeaderView.scrollViewDidEndDragging(scrollView, willDecelerate: decelerate)
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            options.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
            tableView.endUpdates()
        }
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(UITableViewCell.self, for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.text = options[safe: indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return .deleteTitle
    }
}

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

    static let enterNewOption = NSLocalizedString("Enter a new option", comment: "Enter a new optio title")
    static let doneButtonTitle = NSLocalizedString("Done", comment: "Done button action title")
    static let cancelButtonTitle = NSLocalizedString("Cancel", comment: "Cancel button action title")
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

    private var tableView: UITableView {
        return homeView.tableView
    }

    private var options: [String] = ["Option 1", "Option 2", "Option 3", "Option 4"]

    // MARK: - View Lifecycle

    override func loadView() {
        view = homeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        options = []
        for index in 0...30 {
            options.append("Option \(index)")
        }

        tableView.contentInset = UIEdgeInsets(bottom: view.safeAreaInsets.bottom + HomeView.Sizing.startButtonHeight + 20)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCell(UITableViewCell.self)

        homeView.startButton.addTarget(self, action: #selector(onStartButtonTapped), for: .touchUpInside)
        homeView.addOptionButton.addTarget(self, action: #selector(onAddOptionButtonTapped), for: .touchUpInside)
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

// MARK: - UITableViewDataSource

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

// MARK: - Actions

private extension HomeViewController {

    @objc private func onStartButtonTapped() {

    }

    @objc private func onAddOptionButtonTapped() {

        let alert = UIAlertController(title: .enterNewOption, message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.returnKeyType = .done
            textField.autocapitalizationType = .words
        }

        let doneAction = UIAlertAction(title: .doneButtonTitle, style: .default) { [weak self] (_) in
            guard let self = self, let textField = alert.textFields?.first,
                let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                !text.isEmpty else {
                return
            }
            self.tableView.beginUpdates()
            self.options.append(text)
            self.tableView.insertRows(at: [IndexPath(row: self.options.count - 1, section: 0)], with: .right)
            self.tableView.endUpdates()
        }

        let cancelAction = UIAlertAction(title: .cancelButtonTitle, style: .cancel, handler: nil)

        alert.addAction(doneAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
}

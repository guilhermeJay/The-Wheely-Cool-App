//
//  SpinWheelViewController.swift
//  Wheely Cool App
//
//  Created by Guilherme Politta on 10/10/18.
//  Copyright © 2018 Guilherme Politta. All rights reserved.
//

import UIKit

class SpinWheelViewController: UIViewController {

    private lazy var spinWheelView: SpinWheelView = SpinWheelView(frame: UIScreen.main.bounds, options: options)
    private let options: [String]

    init(options optionsParam: [String]) {
        options = optionsParam
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = spinWheelView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        spinWheelView.spinButton.addTarget(self, action: #selector(onSpinButtonTapped), for: .touchUpInside)
    }
}

private extension SpinWheelViewController {
    @objc private func onSpinButtonTapped(_ sender: UIButton) {
        sender.isEnabled = false

        var count: Int = 0
        let max: Int = Int.random(in: 5...50)
        Timer.scheduledTimer(withTimeInterval: 0.07, repeats: true) { [weak self] (timer) in
            count += 1
            self?.spinWheelView.rotate()
            if count == max {
                timer.invalidate()
                sender.isEnabled = true
            }
        }
    }
}

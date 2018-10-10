//
//  SpinWheelView.swift
//  Wheely Cool App
//
//  Created by Guilherme Politta on 10/10/18.
//  Copyright © 2018 Guilherme Politta. All rights reserved.
//

import UIKit

private extension String {
    static let spinButtonTitle = NSLocalizedString("Spin", comment: "Spin button title")
}

class SpinWheelView: UIView {

    enum Sizing {
        static let floatingHeaderViewHeight: CGFloat = 44
        static let horizontalPadding: CGFloat = 20
        static let headerViewSize: CGSize = CGSize(width: UIScreen.main.bounds.width, height: 55)
        static let startButtonHeight: CGFloat = 52
        static let insets: UIEdgeInsets = UIEdgeInsets(x: horizontalPadding)
    }

    private let options: [String]

    // MARK: - Inits

    init(frame: CGRect, options optionsParam: [String]) {
        options = optionsParam
        super.init(frame: frame)
        backgroundColor = .white

        addSubview(wheel)
        wheel.center = center
        addSubview(spinButton)

        NSLayoutConstraint.activate([
            spinButton.heightAnchor.constraint(equalToConstant: Sizing.startButtonHeight),
            spinButton.boxAnchor.constraints(equalTo: safeAreaLayoutGuide.boxAnchor, edgeAnchors: .allExceptTop,
                                              insets: Sizing.insets)
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func rotate() {
        wheel.transform = wheel.transform.rotated(by: -0.78)
    }

    // MARK: - Subviews

    private lazy var wheel: WheelView = WheelView(frame: CGRect(x: 0, y: 0, width: frame.width - 40, height: frame.width - 40),
                                                  options: options)

    let spinButton: UIButton = {
        let result = UIButton()
        result.setTitle(.spinButtonTitle, for: .normal)
        result.setTitleColor(.darkText, for: .normal)
        result.setTitleColor(UIColor.darkText.withAlphaComponent(0.5), for: .disabled)
        result.backgroundColor = .white
        result.layer.cornerRadius = 10
        result.layer.borderWidth = 1
        result.layer.borderColor = UIColor.black.cgColor
        result.translatesAutoresizingMaskIntoConstraints = false
        return result
    }()

}

extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}

private class WheelView: UIView {

    let options: [String]

    init(frame: CGRect, options optionParams: [String]) {
        options = optionParams
        super.init(frame: frame)

        backgroundColor = .black
        layer.cornerRadius = height / 2
        clipsToBounds = true
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupView() {
        let angleSize: CGFloat = (2*CGFloat.pi)/CGFloat(options.count)
        print("\(angleSize.radiansToDegrees)")
        for (index, option) in options.enumerated() {
            let sectionView = SectionView(frame: CGRect(x: 0, y: 0, width: width, height: height), angle: angleSize)
            sectionView.textLayer.string = option
            sectionView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            sectionView.layer.position = center
            sectionView.transform = CGAffineTransform(rotationAngle: angleSize * CGFloat(index))
            addSubview(sectionView)
        }
    }
}

private class WheelLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)

        textColor = .white
        font = .systemFont(ofSize: 12)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private class SectionView: UIView {

    let textLayer = CATextLayer()
    private let angle: CGFloat

    init(frame: CGRect, angle angleParam: CGFloat) {
        self.angle = angleParam
        super.init(frame: frame)
        layer.addSublayer(textLayer)
        backgroundColor = .clear
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {

        guard let context = UIGraphicsGetCurrentContext() else { return }

        let center = rect.center
        let radius = rect.width/2

        let startAngle = CGFloat(90).degreesToRadians
        let endAngle = startAngle + angle

        context.move(to: center)
        context.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        context.closePath()
        context.setFillColor(UIColor.randomColor().cgColor)
        context.fillPath()

        textLabel(centre: center, radius: radius, startAngle: startAngle, endAngle: endAngle)
    }

    func textLabel(centre: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat) {
        // Equation from StackOverflow: http://stackoverflow.com/a/17427257/1694526
        let midAngle = (endAngle + startAngle)/2
        let x = centre.x + radius * cos(midAngle)
        let y = centre.y + radius * sin(midAngle)

        let width: CGFloat = self.width / 2
        let height: CGFloat = 25

        textLayer.frame = CGRect(x: 0, y: 0, width: width, height: height)
        textLayer.position = CGPoint(x: x, y: y)
        textLayer.anchorPoint = CGPoint(x: 0, y: 0)
        textLayer.setAffineTransform(textLayer.affineTransform().rotated(by: CGFloat(-90.0).degreesToRadians))
        textLayer.foregroundColor = UIColor.white.cgColor
        textLayer.fontSize = 12
    }
}

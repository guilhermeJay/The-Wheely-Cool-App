//
//  FloatingHeaderView.swift
//  Contento
//
//  Created by Guilherme Politta on 2/08/18.
//  Copyright © 2018 Roam Ltd. All rights reserved.
//

import UIKit
import RoamSwiftKit

protocol FloatingHeaderViewDelegate: class {
    func onAnimateIn()
    func onAnimateOut()
}

enum FloatingHeaderViewPadding {
    /// default is none
    case `default`
    /// 0
    case none
    /// Spacing.medium
    case medium
    case custom(value: CGFloat)

    var value: CGFloat {
        switch self {
        case .default, .none:
            return 0
        case .medium:
            return 20
        case .custom(let value):
            return value
        }
    }
}

class FloatingHeaderView: UIView {

    weak var delegate: FloatingHeaderViewDelegate?

    var isAnimatingTitle: Bool = false

    private let titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .darkText
        label.translatesAutoresizingMaskIntoConstraints = false
        label.alpha = 0.0
        return label
    }()

    var titleColor: UIColor = .darkText {
        didSet {
            titleLabel.textColor = titleColor
        }
    }

    var title: String? {
        didSet {
            titleLabel.attributedText = title?.withLineHeight(20.0/16.0, textAlignment: .center)
        }
    }

    /// default is 0.25
    var scrollThreshold: CGFloat = 0.25

    private let leadingContainer: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let trailingContainer: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private enum Size {
        static let viewSize: CGSize = CGSize(width: 44, height: 44)
    }

    var bigTitleHeight: CGFloat

    init(bigTitleHeight: CGFloat) {
        self.bigTitleHeight = bigTitleHeight

        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.white

        addSubview(leadingContainer)
        addSubview(trailingContainer)
        addSubview(titleLabel)
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        NSLayoutConstraint.activate([
            leadingContainer.boxAnchor.constraints(equalTo: safeAreaLayoutGuide.boxAnchor, edgeAnchors: .allExceptTrailing),
            trailingContainer.boxAnchor.constraints(equalTo: safeAreaLayoutGuide.boxAnchor, edgeAnchors: .allExceptLeading),

            leadingContainer.widthAnchor.constraint(equalTo: trailingContainer.widthAnchor),

            titleLabel.leadingAnchor.constraint(equalTo: leadingContainer.trailingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingContainer.leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor)
        ])

        nextLeadingAnchor = leadingContainer.leadingAnchor
        nextTrailingAnchor = trailingContainer.trailingAnchor
    }

    private var nextLeadingAnchor: NSLayoutAnchor<NSLayoutXAxisAnchor>?
    private var leadingContainerConstraint: NSLayoutConstraint?

    func addLeadingView(_ view: UIView, padding: FloatingHeaderViewPadding = .default) {
        leadingContainer.addSubview(view)

        if let nextLeadingAnchor = nextLeadingAnchor {
            NSLayoutConstraint.activate([
                view.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
                view.sizeAnchor.constraints(greaterThanOrEqualToConstant: Size.viewSize),
                view.leadingAnchor.constraint(equalTo: nextLeadingAnchor, constant: padding.value)
            ])
        }

        leadingContainerConstraint?.isActive = false
        leadingContainerConstraint = leadingContainer.trailingAnchor.constraint(greaterThanOrEqualTo: view.trailingAnchor)
        leadingContainerConstraint?.isActive = true

        nextLeadingAnchor = view.trailingAnchor
    }
    func removeLeadingViews() {
        leadingContainer.subviews.forEach { (subview) in
            subview.removeFromSuperview()
            NSLayoutConstraint.deactivate(subview.constraints)
        }
        nextLeadingAnchor = leadingContainer.leadingAnchor
    }

    private var nextTrailingAnchor: NSLayoutAnchor<NSLayoutXAxisAnchor>?
    private var trailingContainerConstraint: NSLayoutConstraint?
    func addTrailingView(_ view: UIView, padding: FloatingHeaderViewPadding = .default) {
        trailingContainer.addSubview(view)

        if let nextTrailingAnchor = nextTrailingAnchor {
            NSLayoutConstraint.activate([
                view.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
                view.sizeAnchor.constraints(greaterThanOrEqualToConstant: Size.viewSize),
                view.trailingAnchor.constraint(equalTo: nextTrailingAnchor, constant: -padding.value)
            ])
        }

        trailingContainerConstraint?.isActive = false
        trailingContainerConstraint = trailingContainer.leadingAnchor.constraint(lessThanOrEqualTo: view.leadingAnchor)
        trailingContainerConstraint?.isActive = true

        nextTrailingAnchor = view.leadingAnchor
    }
    func removeTrailingViews() {
        trailingContainer.subviews.forEach { (subview) in
            subview.removeFromSuperview()
            NSLayoutConstraint.deactivate(subview.constraints)
        }
        nextTrailingAnchor = trailingContainer.trailingAnchor
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Animations
extension FloatingHeaderView: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let normalizedScrollPosition: CGFloat = scrollView.getNormalizedScrollPosition(bigTitleHeight)
        layer.shadowOpacity = 1.0 - Float(normalizedScrollPosition)

        if normalizedScrollPosition > scrollThreshold {
            animateTitleOut(scrollView)
        } else {
            animateTitleIn(scrollView)
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard !scrollView.isTracking, !scrollView.isDragging else {
            return
        }

        scrollToTop(scrollView)
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard !decelerate, !scrollView.isDragging else {
            return
        }

        scrollToTop(scrollView)
    }

    func scrollToTop(_ scrollView: UIScrollView) {
        let normalizedScrollPosition: CGFloat = scrollView.getNormalizedScrollPosition(bigTitleHeight)

        if normalizedScrollPosition > 0.5 {

            UIView.animate(withDuration: WheelyAnimation.medium, animations: {
                scrollView.setContentOffset(CGPoint(x: 0.0, y: -scrollView.contentInset.top), animated: false)
            })
        } else if normalizedScrollPosition <= 0.5 && normalizedScrollPosition > 0.0 {

            UIView.animate(withDuration: WheelyAnimation.medium, animations: {
                scrollView.setContentOffset(CGPoint(x: 0.0, y: -scrollView.contentInset.top + self.bigTitleHeight), animated: false)
            })
        }
    }

    func animateTitleOut(_ scrollView: UIScrollView) {
        guard isAnimatingTitle == false, titleLabel.alpha > 0.0 else {
            return
        }

        isAnimatingTitle = true

        UIView.animate(withDuration: WheelyAnimation.medium, animations: {
            self.titleLabel.alpha = 0.0
            self.delegate?.onAnimateOut()
        }, completion: { (_) in
            self.isAnimatingTitle = false
            let normalizedScrollPosition: CGFloat = scrollView.getNormalizedScrollPosition(self.bigTitleHeight)

            if normalizedScrollPosition < self.scrollThreshold {
                self.animateTitleIn(scrollView)
            }
        })
    }

    func animateTitleIn(_ scrollView: UIScrollView) {
        guard isAnimatingTitle == false, titleLabel.alpha < 1.0 else {
            return
        }

        isAnimatingTitle = true

        UIView.animate(withDuration: WheelyAnimation.medium, animations: {
            self.titleLabel.alpha = 1.0
            self.delegate?.onAnimateIn()
        }, completion: { (_) in
            self.isAnimatingTitle = false
            let normalizedScrollPosition: CGFloat = scrollView.getNormalizedScrollPosition(self.bigTitleHeight)

            if normalizedScrollPosition >= self.scrollThreshold {
                self.animateTitleOut(scrollView)
            }
        })
    }
}

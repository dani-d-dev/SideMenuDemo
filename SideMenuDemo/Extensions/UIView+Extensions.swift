//
//  UIView+Extensions.swift
//  SideMenuDemo
//
//  Created by Daniel Daverio on 14/01/2020.
//  Copyright © 2020 com.home.SideMenuDemo. All rights reserved.
//

import UIKit

extension UIStackView {
    convenience init(
        axis: NSLayoutConstraint.Axis = .horizontal,
        alignment: UIStackView.Alignment = .center,
        distribution: UIStackView.Distribution = .equalSpacing,
        spacing: CGFloat = 0.0
    ) {
        self.init()
        self.axis = axis
        self.alignment = alignment
        self.spacing = spacing
    }
    
    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach { addArrangedSubview($0) }
    }
    
    static var row: UIStackView {
        return UIStackView(
            axis: .horizontal,
            alignment: .fill,
            distribution: .fill,
            spacing: 2.0
        )
    }
    
    static var column: UIStackView {
        return UIStackView(
            axis: .vertical,
            alignment: .fill,
            distribution: .fill,
            spacing: 2.0
        )
    }
}

extension UIView {
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        DispatchQueue.main.async {
            let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius, height: radius))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = self.bounds
            maskLayer.path = path.cgPath
            self.layer.mask = maskLayer
        }
    }
}

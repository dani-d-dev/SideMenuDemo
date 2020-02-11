//
//  RoundedButton.swift
//  SideMenuDemo
//
//  Created by Daniel Daverio on 28/01/2020.
//  Copyright © 2020 com.home.SideMenuDemo. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {

    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                layer.borderColor = UIColor.accent.cgColor
            } else {
                layer.borderColor = UIColor.gray.cgColor
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func commonInit() {
        setTitleColor(.accent, for: .normal)
        setTitleColor(.white, for: .highlighted)
        setBackgroundColor(color: .accent, forState: .highlighted)
        setTitleColor(.gray, for: .disabled)

        titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        layer.cornerRadius = 5
        layer.borderWidth = 1.0
        layer.masksToBounds = true
    }
}

extension UIButton {
    func setBackgroundColor(color: UIColor, forState: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.setBackgroundImage(colorImage, for: forState)
    }
}

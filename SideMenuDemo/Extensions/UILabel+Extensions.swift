//
//  UILabel+Extensions.swift
//  SideMenuDemo
//
//  Created by Daniel Daverio on 28/01/2020.
//  Copyright © 2020 com.home.SideMenuDemo. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    convenience init(
        font: UIFont,
        textColor: UIColor = .black,
        backgroundColor: UIColor = .white,
        alignment: NSTextAlignment = .left
    ) {
        self.init()
        self.font = font
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.textAlignment = alignment
    }
}

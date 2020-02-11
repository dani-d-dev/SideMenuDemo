//
//  UITableView+Extensions.swift
//  SideMenuDemo
//
//  Created by Daniel Daverio on 28/01/2020.
//  Copyright © 2020 com.home.SideMenuDemo. All rights reserved.
//

import UIKit

enum RegisterMethod {
    case nib(UINib)
    case classReference(UIView.Type)
}

protocol ReusableCell {
    static var reuseIdentifier: String { get }
}

extension ReusableCell {
    static var reuseIdentifier: String {
        return String(describing: self.self)
    }
}

extension UITableView {
    func register<T: UITableViewCell>(_ type: T.Type) where T: ReusableCell {
        register(type.self, forCellReuseIdentifier: type.reuseIdentifier)
    }
}


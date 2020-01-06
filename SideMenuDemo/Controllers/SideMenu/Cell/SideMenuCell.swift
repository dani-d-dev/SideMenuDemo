//
//  SideMenuCell.swift
//  SideMenuDemo
//
//  Created by Daniel Daverio on 05/01/2020.
//  Copyright © 2020 com.home.SideMenuDemo. All rights reserved.
//

import UIKit

class SideMenuCell: UITableViewCell {

    func configure(model: SideMenuCellViewModel) {
        textLabel?.text = model.title
    }

}

extension NSObject {
    static var identifier: String {
        return String(describing: self)
    }
}

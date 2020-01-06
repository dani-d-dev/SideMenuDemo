//
//  SideMenuCellViewModel.swift
//  ayoba-ios
//
//  Created by Daniel Daverio on 02/01/2020.
//  Copyright © 2020 Apiumhub. All rights reserved.
//

import UIKit

enum SideMenuOption: Int {
    case chats
    case calls
    case status
    case transfers
    case channels
    case account
    case settings
    
    var value: Int {
        return self.rawValue
    }
}

protocol BaseMenuCellViewModel {
    var image: UIImage? { get set }
    var title: String { get set }
    var option: SideMenuOption { get set }
}

extension BaseMenuCellViewModel {
    var image: UIImage? { return nil }
    var title: String { return "No title yet" }
    var option: SideMenuOption { return .chats }
}

struct SideMenuCellViewModel: BaseMenuCellViewModel {
    var image: UIImage?
    var title: String
    var option: SideMenuOption
}

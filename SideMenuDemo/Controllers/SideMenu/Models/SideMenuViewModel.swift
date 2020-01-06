//
//  SideMenuViewModel.swift
//  ayoba-ios
//
//  Created by Daniel Daverio on 02/01/2020.
//  Copyright © 2020 Apiumhub. All rights reserved.
//

import RxSwift

struct SideMenuViewModel {
    let dataSource = Observable.just([
        SideMenuCellViewModel(image: UIImage(named: "chats"), title: "Chats", option: .chats),
        SideMenuCellViewModel(image: UIImage(named: "call"), title: "Calls", option: .calls),
        SideMenuCellViewModel(image: UIImage(named: "status"), title: "Status", option: .status),
        SideMenuCellViewModel(image: UIImage(named: "transfers"), title: "Transfers", option: .transfers),
        SideMenuCellViewModel(image: UIImage(named: "channels"), title: "Channels", option: .channels),
        SideMenuCellViewModel(image: UIImage(named: "account"), title: "Account", option: .account),
        SideMenuCellViewModel(image: UIImage(named: "settings"), title: "Configuration", option: .settings)
    ])
}

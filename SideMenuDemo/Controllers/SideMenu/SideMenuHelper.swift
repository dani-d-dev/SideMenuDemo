//
//  SideMenuHelper.swift
//  ayoba-ios
//
//  Created by Daniel Daverio on 02/01/2020.
//  Copyright © 2020 Apiumhub. All rights reserved.
//

import SideMenu
import UIKit

// swiftlint:disable all
final class SideMenuHelper {
    // MARK: Properties
    
    let menuViewController: SideMenuNavigationController
    private let rootViewController: SideMenuViewController
    
    // MARK: Life cycle
    
    init(
        leftSide: Bool = true,
        presentationStyle: SideMenuPresentationStyle = .viewSlideOutMenuIn,
        presentingEndAlpha: CGFloat = 0.5
    ) {
        rootViewController = SideMenuViewController.newInstance()
        menuViewController = SideMenuNavigationController(rootViewController: rootViewController)
        menuViewController.leftSide = leftSide
        menuViewController.presentationStyle = presentationStyle
        menuViewController.presentationStyle.presentingEndAlpha = presentingEndAlpha
        SideMenuManager.default.leftMenuNavigationController = menuViewController
    }
    
    // MARK: Methods
    
    func configure(navigationBar: UINavigationBar?) {
        guard let navBar = navigationBar else { return }
        SideMenuManager.default.addPanGestureToPresent(toView: navBar)
    }
    
    func present(
        from viewController: UIViewController?,
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        DispatchQueue.main.async { [weak self] in
            guard let vc = self?.menuViewController else { return }
            viewController?.present(vc, animated: animated, completion: completion)
        }
    }
    
    func dismiss(animated: Bool = false, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async { [weak self] in
            self?.menuViewController.dismiss(animated: animated, completion: completion)
        }
    }
    
    func onSelectedItem(closure: @escaping (SideMenuCellViewModel) -> Void) {
        DispatchQueue.main.async { [weak self] in
            self?.rootViewController.onSelectedItem {
                closure($0)
            }
        }
    }
}

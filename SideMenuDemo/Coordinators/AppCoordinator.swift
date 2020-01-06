//
//  AppCoordinator.swift
//  SideMenuDemo
//
//  Created by Daniel Daverio on 05/01/2020.
//  Copyright © 2020 com.home.SideMenuDemo. All rights reserved.
//

import UIKit

final class AppCoordinator {
    private let window: UIWindow
    private let rootNvc: UINavigationController
    private var rootCoordinator: RootCoordinator

    init(window: UIWindow, rootNvc: UINavigationController = UINavigationController()) {
        self.window = window
        self.rootNvc = rootNvc
        self.rootCoordinator = RootCoordinator(root: rootNvc)
    }

    func start() {
        setupRootCoordinator()
    }

    func setupRootCoordinator() {
        
        let firstCoordinator = FirstCoordinator(parent: rootCoordinator)
        let secondCoordinator = SecondCoordinator(parent: rootCoordinator)

        // set childs ...
        rootCoordinator.childs = [firstCoordinator, secondCoordinator]

        // TODO:

        window.rootViewController = rootCoordinator.root
        window.makeKeyAndVisible()

        rootCoordinator.presentHome()
    }
}

final class RootCoordinator: Coordinator {
    var root: UINavigationController
    var parent: Coordinator?
    var childs: [Coordinator] = []
    private var menu: SideMenuHelper?

    init(
        menu: SideMenuHelper? = SideMenuHelper(),
        parent: Coordinator? = nil,
        root: UINavigationController = UINavigationController()
    ) {
        self.parent = parent
        self.root = root
        self.menu = menu
        setupMenu()
    }

    private func setupMenu() {
        menu?.onSelectedItem { [weak self] menuItem in
            guard let strongSelf = self else { return }
            strongSelf.navigate(to: menuItem.option)
        }

        menu?.configure(view: root.view, navigationBar: root.navigationBar)
    }

    private func navigate(to option: SideMenuOption? = .chats) {
        
        guard let option = option else { return }
        
        switch option {
        case .chats:
            guard let coordinator = childs[0] as? SideMenuCoordinator else { return }
            coordinator.push(from: menu, to: nil)
        case .calls:
            guard let coordinator = childs[1] as? SideMenuCoordinator else { return }
            coordinator.push(from: menu, to: nil)
        case .status:
            guard let coordinator = childs[0] as? SideMenuCoordinator else { return }
            coordinator.push(from: menu, to: option)
        default:
            break
        }
    }

    func presentHome() {
        guard let coordinator = childs[0] as? SideMenuCoordinator else { return }
        coordinator.push(from: nil, to: nil)
    }

    func showMenu(from vc: UIViewController?) {
        menu?.present(from: vc)
    }

    func dismiss() {}

    func reset() {}
}

protocol Coordinator: class {
    var parent: Coordinator? { get set }
    var childs: [Coordinator] { get set }
    var root: UINavigationController { get set }
    func showMenu(from vc: UIViewController?)
    func dismiss()
    func reset()
}

protocol MenuCoordinable: class {
    func push(from menu: SideMenuHelper?, to option: SideMenuOption?)
}

typealias SideMenuCoordinator = Coordinator & MenuCoordinable

// MARK: Each vc coordinator

final class FirstCoordinator: SideMenuCoordinator {
    var root: UINavigationController
    var parent: Coordinator?
    var childs: [Coordinator]
    private let vc: Coordinable
    private let detailVc: UIViewController

    init(
        parent: Coordinator?,
        childs: [Coordinator] = [],
        root: UINavigationController = UINavigationController(),
        vc: Coordinable = FirstViewController()
    ) {
        self.parent = parent
        self.childs = childs
        self.root = root
        detailVc = FirstDetailViewController()
        self.vc = vc
        self.vc.parentCoordinator = self
        self.root.viewControllers = [vc]
    }

    func push(from menu: SideMenuHelper?, to option: SideMenuOption? = nil) {
        guard let menu = menu else {
            parent?.root.setViewControllers([vc], animated: true)
            return
        }
        reset()
        
        guard let option = option else {
            menu.menuViewController.pushViewController(vc, animated: true)
            return
        }
        
        // Check detail level navigation
        switch option {
        case .status:
            parent?.root.viewControllers = [vc] // Put the first vc on stack
            menu.menuViewController.pushViewController(detailVc, animated: true) // push detail vc at last
        default: break
        }
    }

    func showMenu(from vc: UIViewController?) {
        parent?.showMenu(from: vc)
    }

    func dismiss() {
        // TODO:
        vc.dismiss(animated: true)
    }

    func reset() {
        parent?.root.viewControllers = []
    }
}

final class SecondCoordinator: SideMenuCoordinator {
    var root: UINavigationController
    var parent: Coordinator?
    var childs: [Coordinator]
    private let vc: Coordinable

    init(
        parent: Coordinator?,
        childs: [Coordinator] = [],
        root: UINavigationController = UINavigationController(),
        vc: Coordinable = SecondViewController()
    ) {
        self.parent = parent
        self.childs = childs
        self.root = root
        self.vc = vc
        self.vc.parentCoordinator = self
        self.root.viewControllers = [vc]
    }

    func push(from menu: SideMenuHelper?, to option: SideMenuOption? = nil) {
        guard let menu = menu else {
            parent?.root.setViewControllers([vc], animated: true)
            return
        }
        reset()
        menu.menuViewController.pushViewController(vc, animated: true)
    }

    func showMenu(from vc: UIViewController?) {
        parent?.showMenu(from: vc)
    }

    func dismiss() {
        // TODO:
        vc.dismiss(animated: true)
    }

    func reset() {
        parent?.root.viewControllers = []
    }
}

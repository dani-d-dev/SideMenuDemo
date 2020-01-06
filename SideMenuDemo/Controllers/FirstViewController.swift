//
//  FirstViewController.swift
//  SideMenuDemo
//
//  Created by Daniel Daverio on 05/01/2020.
//  Copyright © 2020 com.home.SideMenuDemo. All rights reserved.
//

import UIKit

protocol Coordinable: UIViewController {
    var parentCoordinator: Coordinator? { get set }
}

class FirstViewController: UIViewController, Coordinable {
    weak var parentCoordinator: Coordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .orange
        title = "First"

        // Navigation bar
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(menuButtonPressed))
    }

    @objc private func menuButtonPressed() {
        // TODO: Call coordinator and show menu
        parentCoordinator?.showMenu(from: self)
    }
}

class FirstDetailViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .blue
        title = "Detail"
    }
}

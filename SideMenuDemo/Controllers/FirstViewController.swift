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
    private var pinCodeView: PinCodeView = {
        PinCodeView()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .orange
        title = "First"

        // Navigation bar
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(menuButtonPressed))
        
        
        // Add pincodeview
        
        view.addSubview(pinCodeView)
        
        pinCodeView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.topMargin.equalToSuperview().offset(60.0)
        }
        
        pinCodeView.addAction { [weak self] result in
            switch result {
            case .success(let text):
                print(text)
                self?.view.backgroundColor = .green
            case .failure(let err):
                print(err)
                self?.view.backgroundColor = .orange
            }
        }
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

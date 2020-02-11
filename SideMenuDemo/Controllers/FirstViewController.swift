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
    
    private var button: UIButton = {
        let view = UIButton()
        view.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        view.backgroundColor = .blue
        return view
    }()
    
    private let webView: WebViewController = {
        let vc = WebViewController()
        vc.modalPresentationStyle = .overFullScreen
        return vc
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
        
//        view.addSubview(pinCodeView)
        view.addSubview(button)
        
//        pinCodeView.snp.makeConstraints {
//            $0.centerX.equalToSuperview()
//            $0.topMargin.equalToSuperview().offset(60.0)
//        }
//
//        pinCodeView.addAction { [weak self] result in
//            switch result {
//            case .success(let text):
//                print(text)
//                self?.view.backgroundColor = .green
//            case .failure(let err):
//                print(err)
//                self?.view.backgroundColor = .orange
//            }
//        }
        
        button.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
//            $0.top.equalTo(pinCodeView.snp.bottom)
            $0.width.height.equalTo(40.0)
        }
    }

    @objc private func menuButtonPressed() {
        // TODO: Call coordinator and show menu
        parentCoordinator?.showMenu(from: self)
    }
    
    @objc private func buttonTapped() {
        
        let vc = LanguageSelectorViewController.newInstance()
        present(vc, animated: true, completion: nil)
        
        // Webview tests

//        URL(string: "https://ayoba.me/privacy-policy-plain/")
//        guard let url = URL(string: "https://ayoba.me/terms-conditions-plain") else { return }
//
//        webView.load(url: url)
//        if #available(iOS 13.0, *) {
//            webView.isModalInPresentation = true
//        } else {
//            // Fallback on earlier versions
//        }
//        webView.modalPresentationStyle = .fullScreen
//        present(webView, animated: true, completion: nil)
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

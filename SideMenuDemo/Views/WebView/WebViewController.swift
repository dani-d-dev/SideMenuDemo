//
//  WebViewController.swift
//  ayoba-ios
//
//  Created by Daniel Daverio on 05/02/2020.
//  Copyright © 2020 com.home.SideMenuDemo. All rights reserved.
//

import UIKit
import WebKit

final class WebViewController: UIViewController {
    private enum Constants {
        static let navBarHeight = CGFloat(44.0)
        static let navBarOffset = CGFloat(22.0)
    }

    private let webView: WKWebView = {
        let view = WKWebView()
        view.allowsBackForwardNavigationGestures = true
        view.scrollView.layer.masksToBounds = false
//        let edgeInsets = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
//        view.scrollView.contentInset = edgeInsets
        view.isOpaque = true
        view.scrollView.backgroundColor = .white
        return view
    }()

    private let spinner: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        view.hidesWhenStopped = true
        return view
    }()

    private let navigationBar: UINavigationBar = {
        let view = UINavigationBar()
        let navItem = UINavigationItem()
        navItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(closePressed(sender:)))
        view.barTintColor = .blue
        view.tintColor = .white
        view.titleTextAttributes = [.foregroundColor: UIColor.white]
        view.items = [navItem]
        view.barStyle = .black
        return view
    }()

    private var isURLLoaded = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {
        view.backgroundColor = .white
        view.addSubview(webView)
        view.addSubview(spinner)
        view.addSubview(navigationBar)

        spinner.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }

        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.left.right.equalToSuperview()
        }

        webView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(Constants.navBarOffset)
            $0.left.right.bottom.equalToSuperview()
        }

        webView.navigationDelegate = self
    }

    func load(url: URL) {
        navigationBar.topItem?.title = "WebView"
        spinner.startAnimating()
        webView.load(URLRequest(url: url))
    }

    @objc private func closePressed(sender _: Any?) {
        dismiss(animated: true)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension WebViewController: WKNavigationDelegate {
    func webView(_: WKWebView, didFinish _: WKNavigation!) {
        spinner.stopAnimating()
    }
}

extension WebViewController {
    static func newInstance() -> WebViewController {
        return WebViewController()
    }
}

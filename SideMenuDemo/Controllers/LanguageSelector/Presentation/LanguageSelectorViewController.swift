//
//  LanguageSelectorViewController.swift
//  ayoba-ios
//
//  Created by Daniel Daverio on 11/02/2020.
//  Copyright © 2020 Apiumhub. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

// swiftlint:disable all
final class LanguageSelectorViewController: UIViewController {
    private enum Constants {
        static let backgroundColor = UIColor.white
        static let footerHeight = CGFloat(100.0)
        static let backupButtonHeight = CGFloat(34.0)
        static let backupButtonInsets = CGFloat(44.0)
        static let headerHeight = CGFloat(177.0)
    }

    // MARK: Properties

    var binder: LanguageSelectorBinder?
    var onSelectedLanguage: ((LanguageCellModel) -> Void)?
    var fetchLanguages: (() -> Void)?

    private lazy var headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerIcon)
        view.backgroundColor = .lightGray
        return view
    }()

    private lazy var headerIcon: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "onboarding_lang")
        view.contentMode = .scaleAspectFill
        return view
    }()

    private let tableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = Constants.backgroundColor
        view.register(LanguageViewCell.self)
        return view
    }()

    private let footerView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.backgroundColor
        return view
    }()

    private let continueButton: UIButton = {
        let view = RoundedButton()
        view.backgroundColor = Constants.backgroundColor
        view.setTitle("continue_button", for: .normal)
        view.addTarget(self, action: #selector(continueButtonPressed(sender:)), for: .touchUpInside)
        view.isEnabled = true
        return view
    }()

    private let disposeBag = DisposeBag()

    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupViews()
        setupBinding()
        fetchLanguages?()
    }

    // MARK: Setup

    private func setupNavigation() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        navigationBar.prefersLargeTitles = false
        navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        navigationBar.isOpaque = true
        navigationBar.isTranslucent = false
    }

    private func setupViews() {
        view.addSubview(headerView)
        view.addSubview(tableView)
        view.addSubview(footerView)
        footerView.addSubview(continueButton)

        headerView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(Constants.headerHeight)
        }

        headerIcon.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(footerView.snp.top)
        }

        footerView.snp.makeConstraints {
            $0.height.equalTo(Constants.footerHeight)
            $0.leading.bottom.trailing.equalToSuperview()
        }

        continueButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.height.equalTo(Constants.backupButtonHeight)
            $0.leading.trailing.equalToSuperview().inset(Constants.backupButtonInsets)
        }
    }

    // MARK: Setup binding

    private func setupBinding() {
        binder?.items
        .drive(tableView.rx.items(
            cellIdentifier: LanguageViewCell.identifier,
            cellType: LanguageViewCell.self
        )) { _, item, cell in
            cell.configure(model: item)
        }
        .disposed(by: disposeBag)

        tableView.rx.modelSelected(LanguageCellModel.self)
        .asDriver()
        .drive(onNext: { [weak self] in
            self?.onSelectedLanguage?($0)
        }).disposed(by: disposeBag)
    }

    // MARK: Action

    @objc private func continueButtonPressed(sender _: Any?) {
        print("continue button pressed")
        print(binder?.currentLanguage)
    }
}

extension LanguageSelectorViewController: LanguageSelectorInput {
    func onSelectedLanguage(action: @escaping (LanguageCellModel) -> Void) {
        onSelectedLanguage = action
    }

    func fetchLanguages(action: @escaping () -> Void) {
        fetchLanguages = action
    }
}

extension LanguageSelectorViewController: LanguageSelectorOutput {
    func showSpinner() {
        // TODO:
    }

    func hideSpinner() {
        // TODO:
    }
}

extension LanguageSelectorViewController {
    static func newInstance() -> UINavigationController {
        let vc = LanguageSelectorViewController()
        vc.binder = LanguageSelectorBinder(view: vc)
        let nvc = UINavigationController(rootViewController: vc)
        nvc.navigationItem.largeTitleDisplayMode = .never
        nvc.navigationBar.topItem?.title = "select_your_language"
        return nvc
    }
}

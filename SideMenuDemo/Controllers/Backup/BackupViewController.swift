//
//  BackupViewController.swift
//  SideMenuDemo
//
//  Created by Daniel Daverio on 28/01/2020.
//  Copyright © 2020 com.home.SideMenuDemo. All rights reserved.
//

import RxCocoa
import RxDataSources
import RxSwift
import UIKit

// swiftlint:disable all
final class BackupViewController: UIViewController {
    private enum Constants {
        static let backgroundColor = UIColor(red: 235 / 255, green: 235 / 255, blue: 241 / 255, alpha: 1.0)
        static let backupButtonBGColor = UIColor(red: 255 / 255.0, green: 193 / 255.0, blue: 7 / 255.0, alpha: 1)
        static let footerHeight = CGFloat(100.0)
        static let backupButtonHeight = CGFloat(34.0)
        static let backupButtonInsets = CGFloat(44.0)
        static let enableBackupCellIndexPath = IndexPath(row: 0, section: 2)
        static let enableWifiCellIndexPath = IndexPath(row: 1, section: 2)
        static let enableFrecCellIndexPath = IndexPath(row: 2, section: 2)
    }

    // MARK: Properties

    var viewModel: BackupViewModel?

    private let tableView: UITableView = {
        let view = UITableView()
        view.separatorStyle = .none
        view.backgroundColor = Constants.backgroundColor
        view.register(BackupHeaderCell.self)
        view.register(BackupPinCodeCell.self)
        view.register(BackupToggleCell.self)
        view.register(BackupFrecuencyCell.self)
        view.isScrollEnabled = false
        return view
    }()

    private let footerView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.backgroundColor
        return view
    }()

    private let backupButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = Constants.backupButtonBGColor
        view.setTitle("Backup now", for: .normal)
        view.titleLabel?.font = .systemFont(ofSize: 15.0, weight: .regular)
        view.setTitleColor(.black, for: .normal)
        view.addTarget(self, action: #selector(backupButtonPressed(sender:)), for: .touchUpInside)
        view.isEnabled = true
        return view
    }()

    private let disposeBag = DisposeBag()

    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBinding()
    }

    // MARK: Setup

    private func setupUI() {
        view.addSubview(tableView)
        view.addSubview(footerView)
        footerView.addSubview(backupButton)

        tableView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.bottom.equalTo(footerView.snp.top)
        }

        footerView.snp.makeConstraints {
            $0.height.equalTo(Constants.footerHeight)
            $0.leading.bottom.trailing.equalToSuperview()
        }

        backupButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.height.equalTo(Constants.backupButtonHeight)
            $0.leading.trailing.equalToSuperview().inset(Constants.backupButtonInsets)
        }
    }

    // MARK: Setup binding sections support through RxDataSources

    private func setupBinding() {
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, BackupCellModel>>(configureCell: { _, table, _, item in
            switch item {
            case let .header(model):
                return self.buildCell(with: model, kind: BackupHeaderCell.self, from: table)
            case let .pinCode(model):
                model.closure = { [weak self] result in
                    self?.handlePinCodeEntry(result, table: table)
                }
                return self.buildCell(with: model, kind: BackupPinCodeCell.self, from: table)
            case let .toggle(model):
                return self.buildCell(with: model, kind: BackupToggleCell.self, from: table)
            case let .frecuency(model):
                return self.buildCell(with: model, kind: BackupFrecuencyCell.self, from: table)
            }
        })

        dataSource.titleForHeaderInSection = { dataSource, index in
            dataSource.sectionModels[index].model
        }

        viewModel?.sections
        .bind(to: tableView.rx.items(dataSource: dataSource))
        .disposed(by: disposeBag)
    }

    // MARK: Handle validations

    private func handlePinCodeEntry(_ result: PinCodeView.PinCodeResult, table: UITableView) {
        guard
            let enableBackupCell = cell(at: Constants.enableBackupCellIndexPath, table: table) as? BackupToggleCell,
            let enableWifiCell = cell(at: Constants.enableWifiCellIndexPath, table: table) as? BackupToggleCell,
            let enablefrecuencyCell = cell(at: Constants.enableFrecCellIndexPath, table: table) as? BackupFrecuencyCell
        else {
            fatalError("There should be registered cells at the given indexes")
        }
        
        switch result {
        case .success:
            enableBackupCell.onToggleValueChanged { isOn in
                enableWifiCell.toggleControlsInteraction(isEnabled: isOn)
                enablefrecuencyCell.toggleControlsInteraction(isEnabled: isOn)
            }
            enableBackupCell.toggleControlsInteraction(isEnabled: true)
        case .failure(_):
            enableBackupCell.toggleControlsInteraction(isEnabled: false)
            enableWifiCell.toggleControlsInteraction(isEnabled: false)
            enablefrecuencyCell.toggleControlsInteraction(isEnabled: false)
        }
    }

    // MARK: Helper methods

    private func buildCell<T: CellConfigurable>(with model: T.Model, kind: T.Type, from table: UITableView) -> T {
        guard let cell = table.dequeueReusableCell(withIdentifier: kind.reuseIdentifier) as? T else {
            fatalError()
        }
        cell.configure(model: model)
        return cell
    }

    private func cell(at indexPath: IndexPath, table: UITableView) -> UITableViewCell? {
        return table.cellForRow(at: indexPath)
    }

    // MARK: Action

    @objc private func backupButtonPressed(sender: Any?) {
        // TODO:
    }
}

extension BackupViewController {
    static func newInstance(
        viewModel: BackupViewModel = BackupViewModel()
    ) -> BackupViewController {
        let vc = BackupViewController()
        vc.viewModel = viewModel
        return vc
    }
}

//
//  SideMenuViewController.swift
//  SideMenuDemo
//
//  Created by Daniel Daverio on 05/01/2020.
//  Copyright © 2020 com.home.SideMenuDemo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class SideMenuViewController: UIViewController {
    
    private var viewModel = SideMenuViewModel()
    private let disposeBag = DisposeBag()
    private var selectedItem: ((SideMenuCellViewModel) -> Void)?
    
    private let tableView: UITableView = {
        let view = UITableView()
        view.register(SideMenuCell.self, forCellReuseIdentifier: SideMenuCell.identifier)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBinding()
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
    }
    
    private func setupBinding() {
        // Datasource
        viewModel.dataSource
        .asDriver(onErrorJustReturn: [])
        .drive(tableView.rx.items(
            cellIdentifier: SideMenuCell.identifier,
            cellType: SideMenuCell.self
        )) { _, item, cell in
            cell.configure(model: item)
        }
        .disposed(by: disposeBag)

        // Delegate
        tableView.rx.modelSelected(SideMenuCellViewModel.self)
        .asDriver()
        .drive(onNext: { [weak self] in
            print($0)
            self?.selectedItem?($0)
        }).disposed(by: disposeBag)
    }
    
    func onSelectedItem(action: @escaping (SideMenuCellViewModel) -> Void) {
        selectedItem = action
    }
}

extension SideMenuViewController {
    static func newInstance() -> SideMenuViewController {
        let vc = SideMenuViewController()
        return vc
    }
}

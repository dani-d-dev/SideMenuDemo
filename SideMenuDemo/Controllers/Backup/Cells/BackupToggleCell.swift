//
//  BackupToggleCell.swift
//  SideMenuDemo
//
//  Created by Daniel Daverio on 28/01/2020.
//  Copyright © 2020 com.home.SideMenuDemo. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class BackupToggleCell: UITableViewCell, CellConfigurable {
    private enum Constants {
        static let insets = NSDirectionalEdgeInsets(top: 6, leading: 15, bottom: 6, trailing: 15)
    }

    // MARK: Proprties

    private let titleLbl: UILabel = {
        UILabel(
            font: .systemFont(ofSize: 17.0, weight: .regular),
            textColor: .black,
            backgroundColor: .clear,
            alignment: .left
        )
    }()

    private let toggleView: UISwitch = {
        let view = UISwitch()
        view.isEnabled = false
        view.setOn(false, animated: false)
        return view
    }()

    private let row: UIStackView = {
        let stack = UIStackView.row
        stack.alignment = .fill
        stack.isLayoutMarginsRelativeArrangement = true
        stack.directionalLayoutMargins = Constants.insets
        return stack
    }()

    private let disposeBag = DisposeBag()
    private let subject = PublishSubject<Void>()

    // MARK: Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    // MARK: Setup

    private func setupViews() {
        selectionStyle = .none
        row.addArrangedSubviews([titleLbl, toggleView])
        addSubview(row)
        row.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        toggleView.rx.controlEvent(.valueChanged).bind(to: subject).disposed(by: disposeBag)
    }

    // MARK: Configure

    func configure(model: BackupToggleModel) {
        titleLbl.text = model.title
        toggleView.setOn(model.enabled, animated: true)
    }

    // MARK: Toggle control

    func toggleControlsInteraction(isEnabled: Bool) {
        toggleView.isEnabled = isEnabled
        toggleView.setOn(isEnabled, animated: true)
        subject.onNext(())
    }

    // MARK: Event listener

    func onToggleValueChanged(closure: @escaping (Bool) -> Void) {
        subject
        .asDriver(onErrorJustReturn: ())
        .drive(onNext: { _ in
            closure(self.toggleView.isOn)
        }).disposed(by: disposeBag)
    }
}

//
//  LanguageViewCell.swift
//  ayoba-ios
//
//  Created by Daniel Daverio on 11/02/2020.
//  Copyright © 2020 Apiumhub. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import UIKit

// Move to a separate file
struct LanguageCellModel {
    let locale: LocaleModel
    var selected: Bool = false
}

final class LanguageViewCell: UITableViewCell, CellConfigurable {
    private enum Constants {
        static let insets = NSDirectionalEdgeInsets(top: 13, leading: 15, bottom: 13, trailing: 15)
    }

    // MARK: Properties

    private let titleLbl: UILabel = {
        UILabel(
            font: .systemFont(ofSize: 17.0, weight: .regular),
            textColor: .black,
            backgroundColor: .clear,
            alignment: .left
        )
    }()

    private let radioButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "disabled")!, for: .normal)
        button.setImage(UIImage(named: "enabled")!, for: .selected)
        button.setImage(UIImage(named: "enabled")!, for: .highlighted)
        button.isUserInteractionEnabled = false
        return button
    }()

    private let row: UIStackView = {
        let stack = UIStackView.row
        stack.alignment = .fill
        stack.isLayoutMarginsRelativeArrangement = true
        stack.directionalLayoutMargins = Constants.insets
        return stack
    }()

    private let disposeBag = DisposeBag()

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
        row.addArrangedSubviews([titleLbl, radioButton])
        addSubview(row)
        row.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    // MARK: Configure

    func configure(model: LanguageCellModel) {
        titleLbl.text = model.locale.name
        radioButton.isSelected = model.selected
    }
}

//
//  BackupHeaderCell.swift
//  SideMenuDemo
//
//  Created by Daniel Daverio on 28/01/2020.
//  Copyright © 2020 com.home.SideMenuDemo. All rights reserved.
//

import UIKit

class BackupHeaderCell: UITableViewCell, CellConfigurable {
    private enum Constants {
        static let insets = NSDirectionalEdgeInsets(top: 6, leading: 15, bottom: 6, trailing: 15)
    }

    // MARK: Properties

    private let row: UIStackView = {
        let stack = UIStackView.row
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.isLayoutMarginsRelativeArrangement = true
        stack.directionalLayoutMargins = Constants.insets
        return stack
    }()

    private let icon: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()

    private let descriptionLbl: UILabel = {
        let view = UILabel(
            font: UIFont.systemFont(ofSize: 14.0, weight: .regular),
            textColor: .black,
            backgroundColor: .clear,
            alignment: .left
        )
        view.numberOfLines = 0
        return view
    }()

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
        addSubview(row)
        row.addArrangedSubviews([icon, descriptionLbl])
        row.snp.makeConstraints { $0.edges.equalToSuperview() }
        descriptionLbl.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.75)
        }
    }

    // MARK: Configure

    func configure(model: BackupHeaderModel) {
        icon.image = model.icon
        descriptionLbl.text = model.title
    }
}

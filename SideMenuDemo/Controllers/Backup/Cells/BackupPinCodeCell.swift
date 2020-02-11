//
//  BackupPinCodeCell.swift
//  SideMenuDemo
//
//  Created by Daniel Daverio on 28/01/2020.
//  Copyright © 2020 com.home.SideMenuDemo. All rights reserved.
//

import UIKit

class BackupPinCodeCell: UITableViewCell, CellConfigurable {
    private enum Constants {
        static let topBottomInset = CGFloat(28.0)
        static let backgroundColor = UIColor(red: 235 / 255, green: 235 / 255, blue: 241 / 255, alpha: 1.0)
    }

    // MARK: Properties

    private let pinCodeView: PinCodeView = {
        let pinCodeView = PinCodeView(inputBackgroundColor: .white)
        return pinCodeView
    }()

    // MARK: Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    // MARK: Setup

    private func setup() {
        selectionStyle = .none
        backgroundColor = Constants.backgroundColor
        addSubview(pinCodeView)
        pinCodeView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(Constants.topBottomInset)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }

    // MARK: Configure

    func configure(
        model: BackupPinCodeModel
    ) {
        pinCodeView.addAction {
            model.closure?($0)
        }
    }
}

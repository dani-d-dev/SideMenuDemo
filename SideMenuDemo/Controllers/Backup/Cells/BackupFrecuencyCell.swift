//
//  BackupFrecuencyCell.swift
//  SideMenuDemo
//
//  Created by Daniel Daverio on 28/01/2020.
//  Copyright © 2020 com.home.SideMenuDemo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

enum PickerSection: Int {
    case daily
    case weekly
    case monthly
    case off
    func description() -> String {
        switch self {
        case .daily: return "Daily"
        case .weekly: return "Weekly"
        case .monthly: return "Monthly"
        default:
            return "Off"
        }
    }
}

class BackupFrecuencyCell: UITableViewCell, CellConfigurable {
    private enum Constants {
        static let insets = NSDirectionalEdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15)
        static let titleFont = UIFont.systemFont(ofSize: 17.0, weight: .regular)
        static let textViewFont = UIFont.systemFont(ofSize: 17.0, weight: .regular)
    }

    // MARK: Properties

    private let titleLbl: UILabel = {
        UILabel(
            font: Constants.titleFont,
            textColor: .black,
            backgroundColor: .clear,
            alignment: .left
        )
    }()
    
    private let textView: UITextView = {
        let view = UITextView()
        view.textContainer.maximumNumberOfLines = 1
        view.textContainer.lineBreakMode = .byTruncatingTail
        view.isEditable = false
        view.textColor = .lightGray
        view.font = Constants.textViewFont
        view.text = PickerSection.off.description()
        view.textAlignment = .right
        view.isUserInteractionEnabled = false
        view.isScrollEnabled = false
        return view
    }()
    
    private let picker: UIPickerView = {
        let view = UIPickerView()
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
    private let pickerItems = Observable.just([
        PickerSection.daily.description(),
        PickerSection.weekly.description(),
        PickerSection.monthly.description(),
        PickerSection.off.description()
    ])

    // MARK: Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupBinding()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        setupBinding()
    }

    // MARK: Setup

    private func setupViews() {
        selectionStyle = .none
        textView.inputView = picker
        row.addArrangedSubviews([titleLbl, textView])
        addSubview(row)
        row.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func setupBinding() {
        pickerItems
        .bind(to: picker.rx.itemTitles) { _, item in
            return "\(item)"
        }
        .disposed(by: disposeBag)
        
        picker.rx.itemSelected
        .observeOn(MainScheduler.instance)
        .subscribe(onNext: { (row, value) in
            self.textView.text = PickerSection(rawValue: row)?.description()
        })
        .disposed(by: disposeBag)
        
        textView.rx.text.changed.subscribe(onNext: {
            print($0)
        }).disposed(by: disposeBag)
    }
    
    // MARK: Configure

    func configure(model: BackupFrecuencyModel) {
        titleLbl.text = model.title
        textView.needsUpdateConstraints()
    }
    
    func toggleControlsInteraction(isEnabled: Bool) {
        textView.isUserInteractionEnabled = isEnabled
    }
}

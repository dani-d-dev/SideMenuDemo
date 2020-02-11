//
//  BackupViewModel.swift
//  SideMenuDemo
//
//  Created by Daniel Daverio on 28/01/2020.
//  Copyright © 2020 com.home.SideMenuDemo. All rights reserved.
//

import RxSwift
import RxCocoa
import RxDataSources

// swiftlint:disable all

protocol CellConfigurable: UITableViewCell, ReusableCell {
    associatedtype Model
    func configure(model: Model)
}

extension CellConfigurable {
    func toggleControlsInteraction(isEnabled: Bool) {
        isUserInteractionEnabled = isEnabled
    }
}

// MARK: Section models

protocol BackupModel {}

struct BackupHeaderModel: BackupModel {
    let title: String
    let icon: UIImage
}

class BackupPinCodeModel: BackupModel {
    var closure: PinCodeView.ResultClosure?
}

struct BackupToggleModel: BackupModel {
    let title: String
    let enabled: Bool
}

struct BackupFrecuencyModel: BackupModel {
    let title: String
    let selected: PickerSection
    // User can pick between monthly, weekly, daily, or off (manual backups only)
}

// MARK: Section enum

enum BackupCellModel {
    case header(BackupHeaderModel)
    case pinCode(BackupPinCodeModel)
    case toggle(BackupToggleModel)
    case frecuency(BackupFrecuencyModel)
}

// MARK: View Model

struct BackupViewModel {
    let sections = Observable.just([
      SectionModel(model: "", items: [
        BackupCellModel.header(BackupHeaderModel(
            title: "Create a PIN to back up your chats in encrypted format. Your PIN is only stored on your device (even we at Ayoba don't know it), so please make sure you don't forget it!" + "\nLast backup date: never",
            icon: UIImage(named: "cloud-backup")!)
        ),
      ]),
      SectionModel(model: "", items: [
        BackupCellModel.pinCode(BackupPinCodeModel())
      ]),
      SectionModel(model: "", items: [
        BackupCellModel.toggle(BackupToggleModel(title: "Enable backups", enabled: false)),
        BackupCellModel.toggle(BackupToggleModel(title: "Backup using wifi only", enabled: false)),
        BackupCellModel.frecuency(BackupFrecuencyModel(title: "Automatic backup", selected: .off))
      ])
    ])
}

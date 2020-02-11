//
//  LanguageSelectorBinder.swift
//  ayoba-ios
//
//  Created by Daniel Daverio on 11/02/2020.
//  Copyright © 2020 Apiumhub. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

// swiftlint:disable all
typealias LanguageSelectorInterface = LanguageSelectorInput & LanguageSelectorOutput

protocol LanguageSelectorInput: UIViewController {
    func onSelectedLanguage(action: @escaping (LanguageCellModel) -> Void)
    func fetchLanguages(action: @escaping () -> Void)
}

protocol LanguageSelectorOutput {
    func showSpinner()
    func hideSpinner()
}

final class LanguageSelectorBinder {
    weak var view: LanguageSelectorInterface?
    var items: Driver<[LanguageCellModel]> {
        return subject.asDriver(onErrorJustReturn: [])
    }

    private let subject = PublishSubject<[LanguageCellModel]>()
    private let disposeBag = DisposeBag()
    private(set) var currentLanguage: LanguageCellModel?

    init(view: LanguageSelectorInterface) {
        self.view = view

        view.onSelectedLanguage { [weak self] model in
            self?.getLanguages(by: model.locale.code)
        }

        view.fetchLanguages { [weak self] in
            self?.getLanguages()
        }
    }

    private func getLanguages(by selectedCode: String = Locale.current.languageCode ?? "") {
        let models = LocaleUtils.availableLanguages().compactMap {
            LanguageCellModel(
                locale: $0,
                selected: $0.code == selectedCode
            )
        }
        currentLanguage = models.filter { $0.selected }.first
        subject.onNext(models)
    }
}

struct LocaleModel {
    let name: String
    let code: String
}

struct LocaleUtils {
    private enum Constants {
        static let iso1Filter = [
            "af", "en", "fr", "ha", "ig", "rw", "lg", "ps", "pt", "sw", "xh", "yo", "zu",
        ]
    }

    static func availableLanguages(filter: [String] = Constants.iso1Filter) -> [LocaleModel] {
        // 1: Get locale
        let locale = Locale.current
        // 2: List all available languages filtered by the ones we should display
        let availableLanguages = Locale.isoLanguageCodes.filter { filter.contains($0) }
        // 3: Map them to a model
        let models = availableLanguages.compactMap {
            LocaleModel(
                name: locale.localizedString(forIdentifier: $0) ?? "Unknown",
                code: $0
            )
        }
        return models
    }
}

// package org.kontalk.data.source.language
//
// import org.kontalk.domain.util.LocaleUtilsContract
// import javax.inject.Inject
//
// class LocaleIsoUtils @Inject constructor() : LocaleUtilsContract {
//
//    @Suppress("LongMethod", "ComplexMethod")
//    override fun toIso6393(languageCode: String): String? {
//        val code: String?
//
//        when (languageCode) {
//            "en" -> code = "eng"
//            "af_ZA" -> code = "afr"
//            "fr" -> code = "fra"
//            "ha" -> code = "hau"
//            "ig" -> code = "ibo"
//            "ju_CI" -> code = "dyu"
//            "lg" -> code = "lug"
//            "pg_CM" -> code = "wes"
//            "pg_NG" -> code = "pcm"
//            "prs" -> code = "prs"
//            "ps_AF" -> code = "pus"
//            "sw" -> code = "swa"
//            "xh" -> code = "xho"
//            "yo" -> code = "yor"
//            "zu" -> code = "zul"
//            "rw" -> code = "kin"
//            else -> code = null
//        }
//
//        return code
//    }
// }

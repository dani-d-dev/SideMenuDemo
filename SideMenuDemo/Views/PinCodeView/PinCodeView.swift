//
//  PinCodeView.swift
//  SideMenuDemo
//
//  Created by Daniel Daverio on 14/01/2020.
//  Copyright © 2020 com.home.SideMenuDemo. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

// swiftlint:disable all
final class PinCodeView: UIView {
    typealias PinCodeResult = Swift.Result<String, PinCodeError>
    typealias ResultClosure = (PinCodeResult) -> Void

    enum PinCodeError: Error {
        case uncompleted
    }

    enum Constants {
        static let numberOfInputs = 4
        static let spacing: CGFloat = 6.0
        static let inputBoxSize = CGSize(width: 35.0, height: 45.0)
        static let inputCornerRadius = CGFloat(4.0)
        static let inputFont = UIFont.systemFont(ofSize: 22.0, weight: .heavy)
        static let inputBackgroundColor = UIColor(red: 235.0 / 255.0, green: 235.0 / 255.0, blue: 235.0 / 255.0, alpha: 1.0)
    }

    // MARK: Properties

    private var actionClosure: ResultClosure?
    private let inputsCount: Int
    private var inputs: [UITextField] = []
    private let disposeBag = DisposeBag()
    private let isSecureTextEntry: Bool
    private let inputBackgroundColor: UIColor
    private var lastCursorPosition: Int = 0
    private var keyboardType: UIKeyboardType
    private let horizontalStackView: UIStackView = {
        UIStackView(
            axis: .horizontal,
            alignment: .fill,
            distribution: .fillEqually,
            spacing: Constants.spacing
        )
    }()

    // MARK: Life cycle

    init(
        numberOfInputs: Int = Constants.numberOfInputs,
        actionClosure _: ResultClosure? = { _ in },
        isSecureTextEntry: Bool = false,
        keyBoardType: UIKeyboardType = .numberPad,
        inputBackgroundColor: UIColor = Constants.inputBackgroundColor
    ) {
        inputsCount = numberOfInputs
        actionClosure = { _ in }
        self.isSecureTextEntry = isSecureTextEntry
        self.inputBackgroundColor = inputBackgroundColor
        keyboardType = keyBoardType
        super.init(frame: .zero)
        setupData()
        setupUI()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Setup

    private func setupData() {
        inputs = (1 ... inputsCount).map {
            let input = buildInput(tag: $0)
            input.rx.controlEvent(.editingChanged)
                .asDriver()
                .drive(onNext: {
                    self.validateEntry(txtField: input)
                }).disposed(by: disposeBag)

            input.rx.controlEvent(.touchDown)
                .asDriver()
                .drive(onNext: {
                    self.lastCursorPosition = input.tag
                    self.actionClosure?(self.buildResponse())
                }).disposed(by: disposeBag)

            return input
        }
    }

    // MARK: Validations

    private func hasMinimumCharacters() -> Bool {
        let minimumCharacters: [Bool] = inputs.compactMap { txtField in
            guard let txt = txtField.text, !txt.isEmpty, txt.count == 1 else { return false }
            return true
        }

        return minimumCharacters.filter { $0 == true }.count == inputs.count
    }

    private func validateEntry(txtField: UITextField) {
        guard
            let txt = txtField.text, txt.count != 0,
            let char = txtField.text?.last
        else {
            lastCursorPosition -= 1
            inputs.filter { $0.tag == lastCursorPosition }.first?.becomeFirstResponder()
            actionClosure?(buildResponse())
            return
        }

        lastCursorPosition = txtField.tag + 1
        txtField.text = String(char)

        if lastCursorPosition <= inputs.count {
            let nextInput = inputs.filter { $0.tag == lastCursorPosition }.first
            nextInput?.becomeFirstResponder()
        } else {
            lastCursorPosition -= 1
        }

        actionClosure?(buildResponse())
    }

    // MARK: Action callbacks

    func addAction(closure: @escaping ResultClosure) {
        actionClosure = closure
    }

    // MARK: Configure UI

    private func setupUI() {
        backgroundColor = .clear
        addSubview(horizontalStackView)
        horizontalStackView.addArrangedSubviews(inputs)
        inputs.forEach {
            $0.snp.makeConstraints {
                $0.width.equalTo(Constants.inputBoxSize.width)
            }
        }
        horizontalStackView.snp.makeConstraints { $0.edges.equalToSuperview() }
        inputs.first?.becomeFirstResponder()
    }

    // MARK: Build input box

    private func buildInput(tag: Int) -> UITextField {
        InputTextField(
            tag: tag,
            keyboardType: keyboardType,
            isSecureTextEntry: isSecureTextEntry,
            backgroundColor: inputBackgroundColor,
            cornerRadius: Constants.inputCornerRadius,
            contentSize: Constants.inputBoxSize
        )
    }

    // MARK: Build response

    private func buildResponse() -> PinCodeResult {
        if hasMinimumCharacters() {
            let chars = inputs.compactMap { $0.text?.first }
            return PinCodeResult.success(String(chars))
        } else {
            return PinCodeResult.failure(.uncompleted)
        }
    }
}

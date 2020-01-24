//
//  InputTextField.swift
//  SideMenuDemo
//
//  Created by Daniel Daverio on 14/01/2020.
//  Copyright © 2020 com.home.SideMenuDemo. All rights reserved.
//

import UIKit

final class InputTextField: UITextField {
    // MARK: Properties

    enum Constants {
        static let defaultSize = CGSize(width: 35, height: 45)
    }

    var contentSize: CGSize = Constants.defaultSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var canBecomeFirstResponder: Bool {
        return true
    }

    private var shouldHightLightBorder: Bool = false {
        didSet {
            hightLightBorder(value: shouldHightLightBorder)
        }
    }

    private let highLightedColor: UIColor
    private let unhighlightedColor: UIColor

    // MARK: Init

    init(
        tag: Int,
        keyboardType: UIKeyboardType = .numberPad,
        isSecureTextEntry: Bool = false,
        backgroundColor: UIColor = .lightGray,
        highLightedColor: UIColor = .blue,
        unhighlightedColor: UIColor = .white,
        cornerRadius: CGFloat = 4.0,
        contentSize: CGSize = Constants.defaultSize
    ) {
        self.highLightedColor = highLightedColor
        self.unhighlightedColor = unhighlightedColor
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        self.tag = tag
        self.keyboardType = keyboardType
        self.isSecureTextEntry = isSecureTextEntry
        self.backgroundColor = backgroundColor
        layer.cornerRadius = cornerRadius
        self.contentSize = contentSize
        setup()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Setup

    private func setup() {
        contentVerticalAlignment = .center
        contentHorizontalAlignment = .center
        textAlignment = .center
        delegate = self
    }

    // MARK: Overrides

    override var intrinsicContentSize: CGSize {
        return contentSize
    }

    override func caretRect(for _: UITextPosition) -> CGRect {
        return .zero
    }

    private func hightLightBorder(value: Bool) {
        layer.borderWidth = value ? 1.0 : 0.0
        layer.borderColor = value ? highLightedColor.cgColor : unhighlightedColor.cgColor
    }
}

// MARK: UITextFieldDelegate4

extension InputTextField: UITextFieldDelegate {
    func textField(_: UITextField, shouldChangeCharactersIn range: NSRange, replacementString _: String) -> Bool {
        return range.location <= 1
    }

    func textFieldDidBeginEditing(_: UITextField) {
        shouldHightLightBorder = true
    }

    func textFieldDidEndEditing(_: UITextField) {
        shouldHightLightBorder = false
    }
}

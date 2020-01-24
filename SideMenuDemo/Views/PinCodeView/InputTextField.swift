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

    // MARK: Init

    init(
        tag: Int,
        keyboardType: UIKeyboardType = .numberPad,
        isSecureTextEntry: Bool = false,
        backgroundColor: UIColor = .lightGray,
        cornerRadius: CGFloat = 4.0,
        contentSize: CGSize = Constants.defaultSize
    ) {
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
}

// MARK: UITextFieldDelegate4

extension InputTextField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return range.location <= 1
    }
}

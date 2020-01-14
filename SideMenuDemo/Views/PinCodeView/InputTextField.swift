//
//  InputTextField.swift
//  SideMenuDemo
//
//  Created by Daniel Daverio on 14/01/2020.
//  Copyright © 2020 com.home.SideMenuDemo. All rights reserved.
//

import UIKit

// MARK: Custom text field

final class InputTextField: UITextField {
    enum Constants {
        static let defaultSize = CGSize(width: 35, height: 45)
    }
    
    var contentSize: CGSize = Constants.defaultSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return contentSize
    }
    
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
        self.layer.cornerRadius = cornerRadius
        self.contentSize = contentSize
        setup()
    }
    
    private func setup() {
        contentVerticalAlignment = .center
        contentHorizontalAlignment = .center
        textAlignment = .center
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func caretRect(for position: UITextPosition) -> CGRect {
        return .zero
    }
}

// MARK: UITextFieldDelegate

extension InputTextField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        return updatedText.count <= 1
    }
}

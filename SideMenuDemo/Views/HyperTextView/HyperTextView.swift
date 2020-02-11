//
//  HyperTextView.swift
//  ayoba-ios
//
//  Created by Daniel Daverio on 05/02/2020.
//  Copyright © 2020 com.home.SideMenuDemo. All rights reserved.
//

import UIKit

struct HyperTextResource {
    let title: String
    let url: URL
    let linkString: String
}

enum LegalInfo {
    case terms
    case privacy
    var resource: HyperTextResource {
        switch self {
        case .terms:
            return HyperTextResource(
                title: "Terms & Conditions",
                url: URL(string: "https://ayoba.me/terms-conditions-plain")!,
                linkString: "terms_of_use"
            )
        default:
            return HyperTextResource(
                title: "Privacy Policy",
                url: URL(string: "https://ayoba.me/privacy-policy-plain/")!,
                linkString: "privacy_policy"
            )
        }
    }
}

final class HyperTextView: UITextView {
    typealias ActionClosure = (HyperTextResource) -> Void
    
    private let txt: String
    private let links: [HyperTextResource]
    private let linkColor: UIColor
    private var actionClosure: ActionClosure?
    
    init(
        txt: String,
        links: [HyperTextResource],
        linkColor: UIColor = .black,
        frame: CGRect = .zero,
        textContainer: NSTextContainer? = nil
    ) {
        self.txt = txt
        self.links = links
        self.linkColor = linkColor
        actionClosure = { _ in }
        super.init(frame: frame, textContainer: textContainer)
        setup()
    }
    
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func selectionRects(for range: UITextRange) -> [UITextSelectionRect] {
        []
    }

    override func caretRect(for position: UITextPosition) -> CGRect {
        CGRect.zero.offsetBy(dx: .greatestFiniteMagnitude, dy: .greatestFiniteMagnitude)
    }
    
    override var canBecomeFirstResponder: Bool {
        return false
    }
    
    private func setup() {
        delegate = self
        dataDetectorTypes = []
        isEditable = false
        isScrollEnabled = false
        linkTextAttributes = [.foregroundColor: linkColor]
        let attrString = NSMutableAttributedString(string: txt)
        links.forEach { resource in
            _ = attrString.setAsLink(
                textToFind: resource.linkString,
                linkURL: resource.url.absoluteString
            )
        }
        attributedText = attrString
    }
    
    func onLinkTapped(closure: @escaping ActionClosure) {
        actionClosure = closure
    }
}

extension HyperTextView: UITextViewDelegate {
    func textView(_: UITextView, shouldInteractWith URL: URL, in _: NSRange, interaction _: UITextItemInteraction) -> Bool {
        if let result = links.filter({ $0.url == URL }).first {
            actionClosure?(result)
        }
        return false
    }
}

extension NSMutableAttributedString {
    public func setAsLink(
        textToFind: String,
        linkURL: String,
        underlineStyle: Int = 1
    ) -> Bool {
        let foundRange = mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            addAttributes([
                NSAttributedString.Key.link: linkURL,
                NSAttributedString.Key.underlineStyle: underlineStyle
            ], range: foundRange)
            return true
        }
        return false
    }
}

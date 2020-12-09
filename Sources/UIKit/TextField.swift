//
//  TextField.swift
//  Base+Extension
//
//  Created by 方林威 on 2020/11/26.
//

import UIKit

public extension UITextField {
    
    
    /// Set all text selected.
    func selectAll() {
        selectedTextRange = textRange(from: beginningOfDocument, to: endOfDocument)
    }
    
    /// Set text in range selected.
    func selected(_ range: Range<String.Index>) {
        guard let text = text, !text.isEmpty else { return }
        selected(NSRange(range, in: text))
    }
    
    /// Set text in range selected.
    func selected(_ range: NSRange) {
        guard let text = text, !text.isEmpty else { return }
        guard let beginning = position(from: beginningOfDocument, offset: range.location),
              let end = position(from: beginningOfDocument, offset: NSMaxRange(range)) else {
            return
        }
        selectedTextRange = textRange(from: beginning, to: end)
    }
}

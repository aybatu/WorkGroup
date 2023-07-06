//
//  TextView.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 05/07/2023.
//

import UIKit

struct TextView {
    func styleTextView(_ textView: UITextView) {
        // Font and Text Color
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = UIColor.black

        // Text Alignment
        textView.textAlignment = .left

        // Text Indentation and Line Spacing
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainer.lineBreakMode = .byWordWrapping
        textView.textContainer.maximumNumberOfLines = 0
        textView.textContainer.lineBreakMode = .byTruncatingTail

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.paragraphStyle: paragraphStyle]
        textView.attributedText = NSAttributedString(string: textView.text, attributes: attributes)

        // Background Color
        textView.backgroundColor = UIColor.white

        // Border and Corners
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.cornerRadius = 5.0
        textView.clipsToBounds = true

        // Scroll Indicators
        textView.showsVerticalScrollIndicator = true
        textView.indicatorStyle = .black // Or .white, depending on the background color
    }
}

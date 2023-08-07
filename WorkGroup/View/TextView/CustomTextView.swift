//
//  CustomTextView.swift
//  WorkGroup
//
//  Created by Aybatu KERKUKLUOGLU on 03/08/2023.
//

import UIKit

class CustomTextView: UITextView {
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let characterCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var placeholder: String? {
        get { return placeholderLabel.text }
        set { placeholderLabel.text = newValue }
    }
    
    override var text: String! {
        didSet {
            placeholderLabel.isHidden = !text.isEmpty
            updateCharacterCount()
        }
    }
    
    override var font: UIFont? {
        didSet {
            placeholderLabel.font = font
            characterCountLabel.font = font
        }
    }
    
    override var textColor: UIColor? {
        didSet {
            placeholderLabel.textColor = textColor?.withAlphaComponent(0.6)
            characterCountLabel.textColor = textColor?.withAlphaComponent(0.6)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
        styleTextView()
        updateCharacterCount()
    }
    
    private func commonInit() {
        addSubview(placeholderLabel)
        addSubview(characterCountLabel)
        
        NSLayoutConstraint.activate([
            placeholderLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            placeholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            placeholderLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            
            characterCountLabel.bottomAnchor.constraint(equalTo: superview!.bottomAnchor, constant: -20),
            characterCountLabel.trailingAnchor.constraint(equalTo: superview!.trailingAnchor, constant: -6),
            
        ])
        
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    @objc private func textDidChange() {
        placeholderLabel.isHidden = !text.isEmpty
        updateCharacterCount()
        limitCharacterCount()
    }
    
    // Styling the text view
    private func styleTextView() {
        // Font and Text Color
        font = UIFont.systemFont(ofSize: 16)
        textColor = UIColor.black
        
        // Text Alignment
        textAlignment = .left

        // Text Indentation and Line Spacing
      
        textContainer.lineFragmentPadding = 0
        textContainer.lineBreakMode = .byWordWrapping
        textContainer.maximumNumberOfLines = 0
        textContainer.lineBreakMode = .byTruncatingTail

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.paragraphStyle: paragraphStyle]
        let padding = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 50)
        textContainerInset = padding
        attributedText = NSAttributedString(string: text, attributes: attributes)

        // Background Color
        backgroundColor = UIColor.white

        // Border and Corners
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.lightGray.cgColor
        layer.cornerRadius = 5.0
        clipsToBounds = true

        characterCountLabel.textColor = UIColor.lightGray
        characterCountLabel.font = font
        
        // Scroll Indicators
        showsVerticalScrollIndicator = true
        indicatorStyle = .black // Or .white, depending on the background color
    }
    
    private func updateCharacterCount() {
        let characterLimit = 200
        let currentCount = text.count
        let remainingCount = characterLimit - currentCount
        characterCountLabel.text = "\(currentCount)/\(characterLimit)"
        characterCountLabel.textColor = remainingCount >= 0 ? .lightGray : .red
    }
    
    private func limitCharacterCount() {
        let characterLimit = 200
        if text.count > characterLimit {
            text = String(text.prefix(characterLimit))
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

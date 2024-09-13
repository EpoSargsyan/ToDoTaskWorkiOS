//
//  TextView.swift
//  ToDoList
//
//  Created by Eprem Sargsyan on 13.09.24.
//

import UIKit

public class TextView: UITextView {
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }

    public override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        commonInit()
    }

    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .systemGray2
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        addSubview(label)
        label.snp.makeConstraints { view in
            view.leading.equalToSuperview().offset(24)
            view.top.equalToSuperview().offset(12)
        }
        return label
    }()

    var placeholderText: String? {
        get { placeholderLabel.text }
        set {
            placeholderLabel.text = newValue
            setPlaceholderLabelHidden()
        }
    }

    var placeholderTextColor: UIColor? {
        get { placeholderLabel.textColor }
        set { placeholderLabel.textColor = newValue }
    }

    public override var text: String! {
        didSet {
            setPlaceholderLabelHidden()
        }
    }

    public override var textColor: UIColor? {
        didSet {
            tintColor = textColor
        }
    }

    public override var textAlignment: NSTextAlignment {
        didSet {
            placeholderLabel.textAlignment = textAlignment
        }
    }

    public override var font: UIFont? {
        didSet {
            placeholderLabel.font = font
        }
    }

    public override var backgroundColor: UIColor? {
        didSet {
            placeholderLabel.backgroundColor = backgroundColor
        }
    }

    func commonInit() {
        textContainerInset = .zero
        textContainer.lineFragmentPadding = 0

        NotificationCenter.default.addObserver(forName: UITextView.textDidChangeNotification, object: nil, queue: nil) { [weak self] _ in
            guard let self = self else { return }
            self.setPlaceholderLabelHidden()
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func setPlaceholderLabelHidden() {
        placeholderLabel.isHidden = (placeholderText ?? "").isEmpty || !text.isEmpty
    }
}

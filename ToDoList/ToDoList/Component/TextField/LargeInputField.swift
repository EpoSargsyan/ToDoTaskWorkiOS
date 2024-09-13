//
//  LargeInputField.swift
//  ToDoList
//
//  Created by Eprem Sargsyan on 13.09.24.
//

import UIKit
import SnapKit

public class LargeInputField: UIView, UITextViewDelegate {
    public let mainLabel: UILabel
    public var textView: TextView

    public init(labelText: String, placeholder: String) {
        self.mainLabel = UILabel()
        self.mainLabel.text = labelText
        self.mainLabel.textColor = .black
        self.mainLabel.font = UIFont.systemFont(ofSize: 20)

        self.textView = TextView()
        self.textView.font = UIFont.systemFont(ofSize: 16)
        self.textView.placeholderText = placeholder
        self.textView.layer.cornerRadius = 24
        self.textView.backgroundColor = UIColor.systemGray4
        self.textView.textContainerInset = UIEdgeInsets(top: 12, left: 24, bottom: 12, right: 24)
        self.textView.autocorrectionType = .no
        self.textView.autocapitalizationType = .none

        super.init(frame: .zero)

        self.addSubview(mainLabel)
        self.addSubview(textView)

        textView.delegate = self

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        mainLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(14)
            make.height.equalTo(17)
        }

        textView.snp.makeConstraints { make in
            make.top.equalTo(mainLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(192)
        }
    }
}


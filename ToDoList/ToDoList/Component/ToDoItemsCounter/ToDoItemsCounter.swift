//
//  ToDoItemsCounter.swift
//  ToDoList
//
//  Created by Eprem Sargsyan on 12.09.24.
//

import UIKit
import SnapKit
import Combine
import ToDoListEntity

final class ToDoItemsCounter: UIView {
    private let button = UIButton(type: .system)

    private let label = UILabel(text: "",
                                textColor: .white,
                                font: UIFont.systemFont(ofSize: 8))

    public var buttonTappedSubject = PassthroughSubject<Void, Never>()

    private func setupUI() {
        self.backgroundColor = .clear

        self.addSubview(button)
        self.addSubview(label)

        button.setTitleColor(.gray, for: .normal)
        button.backgroundColor = .clear
        button.layer.borderWidth = 0

        label.textAlignment = .center
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 8
        label.backgroundColor = .gray

        setupContraints()
    }

    public func setTappedState() {
        button.setTitleColor(.blue, for: .normal)
        label.backgroundColor = .blue
    }

    public func setNormalState() {
        button.setTitleColor(.gray, for: .normal)
        label.backgroundColor = .gray
    }

    public func setLabelText(text: String) {
        label.text = text
    }

    private func makeButtonAction() {
        let buttonAction = UIAction { [weak self] _ in
            self?.buttonTappedSubject.send()
        }

        button.addAction(buttonAction, for: .touchUpInside)
    }

    private func setupContraints() {
        button.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
            make.trailing.equalTo(label.snp.leading).offset(-8)
        }

        label.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview()
            make.width.equalTo(24)
        }
    }
}

extension ToDoItemsCounter: ISetupable {
    typealias SetupModel = ToDoItemsCountPresentationModel

    func setup(with model: ToDoItemsCountPresentationModel) {
        button.setTitle(model.title, for: .normal)
        label.text = "\(model.count)"
        setupUI()
        makeButtonAction()
    }
}

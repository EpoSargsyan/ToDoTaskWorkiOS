//
//  ToDoListTableViewCell.swift
//  ToDoList
//
//  Created by Eprem Sargsyan on 10.09.24.
//

import UIKit
import SnapKit
import ToDoListEntity

class ToDoListTableViewCell: UITableViewCell, IReusableView {
    private let itemView = UIView()

    private let checkBox = UIButton(type: .system)

    private let titleLabel = UILabel(text: "",
                                     textColor: .black,
                                     font: UIFont.systemFont(ofSize: 20))
    private let descriptionLabel = UILabel(text: "jhacbahjbcasjkbcas",
                                           textColor: .gray,
                                           font: UIFont.systemFont(ofSize: 16))

    private let divider = UIView()

    private let dateLabel = UILabel(text: "jjzzoaoaoaoaoao",
                                    textColor: .gray,
                                    font: UIFont.systemFont(ofSize: 18))

    public var isCompleted: Bool = false

    private var width: CGFloat = 0

    private func setupUI() {
        self.backgroundColor = .clear
        self.selectionStyle = .none

        contentView.addSubview(itemView)
        itemView.addSubview(titleLabel)
        itemView.addSubview(descriptionLabel)
        itemView.addSubview(checkBox)
        itemView.addSubview(divider)
        itemView.addSubview(dateLabel)

        itemView.backgroundColor = .white
        itemView.layer.cornerRadius = 16

        divider.backgroundColor = .systemGray2
        divider.layer.cornerRadius = 1

        if isCompleted {
            checkBox.backgroundColor = .cyan
            checkBox.setImage(UIImage(systemName: "checkmark"), for: .normal)
        } else {
            checkBox.backgroundColor = .white
            checkBox.setImage(nil, for: .normal)
        }
        checkBox.layer.cornerRadius = 12
        checkBox.layer.borderWidth = 1
        checkBox.layer.borderColor = UIColor.gray.cgColor

        setupConstraints()
    }

    private func setupConstraints() {
        itemView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(8)
            make.leading.equalTo(contentView.snp.leading).offset(24)
            make.trailing.equalTo(contentView.snp.trailing).inset(24)
            make.bottom.equalTo(contentView.snp.bottom).inset(8)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalTo(checkBox.snp.leading).offset(-16)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(titleLabel.snp.leading)
            make.trailing.equalTo(titleLabel.snp.trailing)
        }

        checkBox.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(22)
            make.trailing.equalToSuperview().inset(16)
            make.width.height.equalTo(24)
        }

        divider.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(2)
        }

        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(divider.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
        }
    }

    private func makeButtonAction() {
        let checkBoxAction = UIAction { [weak self] _ in
            guard let self = self else { return }
            //MARK: Poxel hamel bazai mejiny
            isCompleted.toggle()
            if isCompleted {
                titleLabel.strikeThroughText()
                checkBox.backgroundColor = .cyan
                checkBox.setImage(UIImage(systemName: "checkmark"), for: .normal)
            } else {
                titleLabel.removeStrikethroughText()
                checkBox.backgroundColor = .white
                checkBox.setImage(nil, for: .normal)
            }
        }

        checkBox.addAction(checkBoxAction, for: .touchUpInside)
    }
}

extension ToDoListTableViewCell: ISetupable {
    typealias SetupModel = ToDoItemPresentationModel

    func setup(with model: ToDoItemPresentationModel) {
        titleLabel.text = model.todo
        isCompleted = model.completed
        if model.completed {
            titleLabel.strikeThroughText()
        }
        setupUI()
        makeButtonAction()
    }
}

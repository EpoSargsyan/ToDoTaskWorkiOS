//
//  ToDoListTableViewCell.swift
//  ToDoList
//
//  Created by Eprem Sargsyan on 10.09.24.
//

import UIKit
import SnapKit

class ToDoListTableViewCell: UITableViewCell, IReusableView {
    private let itemView = UIView()

    //MARK: Harcnel esi buttona te che
    private let checkBox = UIButton(type: .system)

    private let titleLabel = UILabel(text: "jhacbahjbcasjkbcas",
                                     textColor: .black,
                                     font: UIFont.systemFont(ofSize: 20))
    private let descriptionLabel = UILabel(text: "jhacbahjbcasjkbcas",
                                           textColor: .gray,
                                           font: UIFont.systemFont(ofSize: 16))

    private let divider = UIView()

    private let dateLabel = UILabel(text: "jjzzoaoaoaoaoao",
                                    textColor: .gray,
                                    font: UIFont.systemFont(ofSize: 18))

    private let doneLine = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        self.backgroundColor = .clear
        self.selectionStyle = .none

        contentView.addSubview(itemView)
        itemView.addSubview(doneLine)
        itemView.addSubview(titleLabel)
        itemView.addSubview(descriptionLabel)
        itemView.addSubview(checkBox)
        itemView.addSubview(divider)
        itemView.addSubview(dateLabel)

        itemView.backgroundColor = .white
        itemView.layer.cornerRadius = 16

        divider.backgroundColor = .systemGray2
        divider.layer.cornerRadius = 1

        checkBox.backgroundColor = .blue
        checkBox.layer.cornerRadius = 12

        doneLine.isHidden = true

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
            make.trailing.equalTo(checkBox.snp.leading).inset(8)
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

//        doneLine.snp.makeConstraints { make in
//            make.centerY.equalTo(titleLabel.snp.centerY)
//        }
    }
}

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
        self.addSubview(itemView)
        itemView.addSubview(doneLine)
        itemView.addSubview(titleLabel)
        itemView.addSubview(descriptionLabel)
        itemView.addSubview(checkBox)
        itemView.addSubview(divider)
        itemView.addSubview(dateLabel)

        doneLine.isHidden = true
        titleLabel.numberOfLines = 0

        setupConstraints()
    }

    private func setupConstraints() {
        
    }
}

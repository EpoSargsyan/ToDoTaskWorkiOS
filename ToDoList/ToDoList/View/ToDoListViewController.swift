//
//  ToDoListViewController.swift
//  ToDoList
//
//  Created by Eprem Sargsyan on 10.09.24.
//

import UIKit
import SnapKit
import ToDoListInteractor
import ToDoListEntity

class ToDoListViewController: BaseViewController {

    var interactor: Interactor?

    private let titleLabel = UILabel(text: "Today's Task",
                                     textColor: .black,
                                     font: UIFont.systemFont(ofSize: 24))
    private let descriptionLabel = UILabel(text: "Asdfghj",
                                           textColor: .gray,
                                           font: UIFont.systemFont(ofSize: 20))

    private let newTaskButton = UIButton(backgroundColor: .cyan,
                                         title: "New Task",
                                         textColor: .black,
                                         image: "plus")

    private let tableView = UITableView(frame: .zero, style: .grouped)

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func setupUI() {
        super.setupUI()

        view.backgroundColor = .systemGray5

        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(newTaskButton)
        view.addSubview(tableView)

        setupConstraints()
        setupTableView()
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(72)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalTo(newTaskButton.snp.leading).inset(16)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(titleLabel.snp.leading)
            make.trailing.equalTo(titleLabel.snp.trailing)
        }

        newTaskButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(80)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(40)
            make.width.equalTo(130)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(200)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    override func setupInteractor() {
        super.setupInteractor()
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none

        tableView.register(ToDoListTableViewCell.self)
    }
}

extension ToDoListViewController: IInteractorableController {
    typealias Interactor = IToDoInteractor
}

extension ToDoListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ToDoListTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "") { [weak self] action, view, completionHandler in
            //MARK: Delete from CoreData
//            guard let topicId = self?.topics[indexPath.row].id else { return }
//            self?.viewModel?.removeBookmark(by: topicId)
            tableView.deleteRows(at: [indexPath], with: .none)
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = UIColor.red
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

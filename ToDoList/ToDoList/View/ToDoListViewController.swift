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

final class ToDoListViewController: BaseViewController {

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

    private let allItems = ToDoItemsCounter()
    private let openItems = ToDoItemsCounter()
    private let closedItems = ToDoItemsCounter()

    private let tableView = UITableView(frame: .zero, style: .grouped)

    private lazy var stackView = UIStackView(arrangedSubviews: [allItems,
                                                                openItems,
                                                                closedItems],
                                             axis: .horizontal,
                                             spacing: 16)

    private var todos: [TodoDetails] {
        return interactor?.result?.todos ?? []
    }

    private var completedCount: Int {
        return todos.filter { $0.completed }.count
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        Task {
            await interactor?.getTodos()
        }

        makeButtonAction()
    }

    override func setupUI() {
        super.setupUI()

        view.backgroundColor = .systemGray5

        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(newTaskButton)
        view.addSubview(stackView)
        view.addSubview(tableView)

        stackView.distribution = .fillProportionally
        stackView.alignment = .center

        allItems.buttonTappedSubject.sink { [weak self] _ in
            self?.allItems.setTappedState()
            self?.openItems.setNormalState()
            self?.closedItems.setNormalState()
        }.store(in: &cancellables)

        openItems.buttonTappedSubject.sink { [weak self] _ in
            self?.allItems.setNormalState()
            self?.openItems.setTappedState()
            self?.closedItems.setNormalState()
        }.store(in: &cancellables)

        closedItems.buttonTappedSubject.sink { [weak self] _ in
            self?.allItems.setNormalState()
            self?.openItems.setNormalState()
            self?.closedItems.setTappedState()
        }.store(in: &cancellables)

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

        stackView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(32)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(100)
            make.height.equalTo(20)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(200)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    override func setupInteractor() {
        super.setupInteractor()

        interactor?.todosSuccessSubject.sink { [weak self] success in

            self?.allItems.setup(with: ToDoItemsCountPresentationModel(title: "All",
                                                                       count: self?.todos.count ?? 0))

            self?.openItems.setup(with: ToDoItemsCountPresentationModel(title: "Open",
                                                                        count: self?.completedCount ?? 0))

            let closedCount = (self?.todos.count ?? 0) - (self?.completedCount ?? 0)

            self?.closedItems.setup(with: ToDoItemsCountPresentationModel(title: "Closed",
                                                                    count: closedCount))
            self?.tableView.reloadData()
        }.store(in: &cancellables)

        interactor?.errorEvent.sink { error in
            print(error.localizedDescription)
        }.store(in: &cancellables)
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none

        tableView.register(ToDoListTableViewCell.self)
    }

    private func makeButtonAction() {
        let newTaskAction = UIAction { [weak self] _ in
            guard let navigationController = self?.navigationController else { return }
            ToDoListRouter.showNewTaskViewController(in: navigationController)
        }

        newTaskButton.addAction(newTaskAction, for: .touchUpInside)
    }
}

extension ToDoListViewController: IInteractorableController {
    typealias Interactor = IToDoInteractor
}

extension ToDoListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ToDoListTableViewCell = tableView.dequeueReusableCell(for: indexPath)

        let model = ToDoItemPresentationModel(todo: todos[indexPath.row].todo,
                                              completed: todos[indexPath.row].completed)
        cell.setup(with: model)
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

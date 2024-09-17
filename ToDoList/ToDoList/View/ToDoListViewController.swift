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
    let context = CoreDataManager.shared.context

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

    private var todos: [ToDoItemCoreData] {
        return interactor?.todosDB ?? []
    }

    private var completedTodos: [ToDoItemCoreData] {
        return todos.filter { $0.completed }
    }

    private var notCompletedTodos: [ToDoItemCoreData] {
        return todos.filter { !$0.completed }
    }

    private var drawingTodos: [ToDoItemCoreData] = []

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor?.loadTodosfromDB(context: self.context)
        drawingTodos = todos
        allItems.setTappedState()
        setCountsForLabels()
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        Task {
            await interactor?.getTodos(context: context)
        }
        interactor?.loadTodosfromDB(context: context)

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

        descriptionLabel.text = getCurrentDate()
        stackView.distribution = .fillProportionally
        stackView.alignment = .center

        allItems.buttonTappedSubject.sink { [weak self] _ in
            self?.allItems.setTappedState()
            self?.openItems.setNormalState()
            self?.closedItems.setNormalState()
            self?.drawingTodos = self?.todos ?? []
            self?.tableView.reloadData()
        }.store(in: &cancellables)

        openItems.buttonTappedSubject.sink { [weak self] _ in
            self?.allItems.setNormalState()
            self?.openItems.setTappedState()
            self?.closedItems.setNormalState()
            self?.drawingTodos = self?.notCompletedTodos ?? []
            self?.tableView.reloadData()
        }.store(in: &cancellables)

        closedItems.buttonTappedSubject.sink { [weak self] _ in
            self?.allItems.setNormalState()
            self?.openItems.setNormalState()
            self?.closedItems.setTappedState()
            self?.drawingTodos = self?.completedTodos ?? []
            self?.tableView.reloadData()
        }.store(in: &cancellables)

        drawingTodos = todos

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

        interactor?.updateCompletedSubject.sink { [weak self] (id, isCompleted) in
            let todo = self?.interactor?.todosDB.first { toDoItemCoreData in
                toDoItemCoreData.id == id
            }
            todo?.completed = isCompleted
            if let context = self?.context {
                self?.interactor?.saveChanges(context: context)
            }
        }.store(in: &cancellables)

        interactor?.todosSuccessSubject.sink { [weak self] success in

            let completedCount = self?.completedTodos.count
            let notCompletedCount = self?.notCompletedTodos.count

            self?.allItems.setup(with: ToDoItemsCountPresentationModel(title: "All",
                                                                       count: self?.todos.count ?? 0))

            self?.openItems.setup(with: ToDoItemsCountPresentationModel(title: "Open",
                                                                        count: notCompletedCount ?? 0))

            self?.closedItems.setup(with: ToDoItemsCountPresentationModel(title: "Closed",
                                                                    count: completedCount ?? 0))

            self?.allItems.setTappedState()
            self?.tableView.reloadData()
        }.store(in: &cancellables)

        (interactor as? BaseInteractor)?.errorEvent.sink { error in
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

    private func getCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, dd MMMM"

        let currentDate = Date()
        let formattedDate = dateFormatter.string(from: currentDate)
        return formattedDate
    }

    private func setCountsForLabels() {
        allItems.setLabelText(text: "\(todos.count)")
        openItems.setLabelText(text: "\(notCompletedTodos.count)")
        closedItems.setLabelText(text: "\(completedTodos.count)")
    }
}

extension ToDoListViewController: IInteractorableController {
    typealias Interactor = IToDoInteractor
}

extension ToDoListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drawingTodos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ToDoListTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        if let updateCompletedSubject = interactor?.updateCompletedSubject {
            let model = ToDoItemPresentationModel(todoModel: drawingTodos[indexPath.row], updateCompletedSubject: updateCompletedSubject)
            cell.setup(with: model)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let navigationController = self.navigationController {
            let model = EditToDoItemNavigatioModel(todo: drawingTodos[indexPath.row])
            ToDoListRouter.showEditToDoItemViewController(in: navigationController,
                                                          navigationModel: model)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "") { [weak self] action, view, completionHandler in
            guard let todo = self?.drawingTodos[indexPath.row] else { return }
            guard let context = self?.context else { return }
            self?.drawingTodos.remove(at: indexPath.row)
            self?.interactor?.delteTodoDB(context: context, item: todo)
            tableView.deleteRows(at: [indexPath], with: .none)
            self?.setCountsForLabels()
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = UIColor.red
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

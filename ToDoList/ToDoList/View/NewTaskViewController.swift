//
//  NewTaskViewController.swift
//  ToDoList
//
//  Created by Eprem Sargsyan on 13.09.24.
//

import UIKit
import SnapKit
import ToDoListInteractor
import ToDoListEntity

final class NewTaskViewController: BaseViewController {

    var interactor: Interactor?

    private var context = CoreDataManager.shared.context

    private var todo: ToDoItemCoreData!

    private let saveButton = UIButton(type: .system)

    private let titleTextField = LargeInputField(labelText: "Title",
                                                 placeholder: "Your ToDo...")
    private let descriptionTextField = UITextField()

    private let datePicker = UIDatePicker()
    private var dateFormatter = DateFormatter()

    private let startingDateTextField = UITextField()
    private let endingDateTextField = UITextField()

    private let divider = UIView()

    private var toolBar = UIToolbar()
    private var isStartingDate: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        makeButtonAction()
    }

    override func setupUI() {
        super.setupUI()
        view.backgroundColor = .white

        view.addSubview(saveButton)
        view.addSubview(titleTextField)
        view.addSubview(descriptionTextField)
        view.addSubview(startingDateTextField)
        view.addSubview(endingDateTextField)
        view.addSubview(divider)

        todo = ToDoItemCoreData(context: context)
        todo.completed = false
        todo.id = UUID()

        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(.black, for: .normal)
        saveButton.backgroundColor = .cyan
        saveButton.layer.cornerRadius = 16

        divider.backgroundColor = .gray

        titleTextField.isUserInteractionEnabled = true

        descriptionTextField.placeholder = "Team name..."
        descriptionTextField.backgroundColor = .systemGray4
        descriptionTextField.layer.cornerRadius = 16

        startingDateTextField.isUserInteractionEnabled = true
        startingDateTextField.inputAccessoryView = toolBar
        startingDateTextField.inputView = datePicker
        startingDateTextField.placeholder = "Starting date"
        startingDateTextField.backgroundColor = .systemGray4
        startingDateTextField.layer.cornerRadius = 16

        endingDateTextField.isUserInteractionEnabled = true
        endingDateTextField.inputAccessoryView = toolBar
        endingDateTextField.inputView = datePicker
        endingDateTextField.placeholder = "Ending date"
        endingDateTextField.backgroundColor = .systemGray4
        endingDateTextField.layer.cornerRadius = 16

        startingDateTextField.delegate = self
        endingDateTextField.delegate = self

        setupDatePicker()
        setupContraints()
    }

    override func setupInteractor() {
        super.setupInteractor()
    }

    private func setupContraints() {
        saveButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(60)
            make.leading.equalToSuperview().offset(16)
            make.width.equalTo(100)
            make.height.equalTo(48)
        }

        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(saveButton.snp.bottom).offset(40)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(192)
        }

        descriptionTextField.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(32)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }

        startingDateTextField.snp.makeConstraints { make in
            make.top.equalTo(descriptionTextField.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.width.equalTo(170)
            make.height.equalTo(48)
        }

        divider.snp.makeConstraints { make in
            make.centerY.equalTo(startingDateTextField.snp.centerY)
            make.leading.equalTo(startingDateTextField.snp.trailing).offset(8)
            make.width.equalTo(5)
            make.height.equalTo(2)
        }

        endingDateTextField.snp.makeConstraints { make in
            make.centerY.equalTo(startingDateTextField.snp.centerY)
            make.leading.equalTo(divider.snp.trailing).offset(8)
            make.width.equalTo(170)
            make.height.equalTo(48)
        }
    }

    private func createToolbar(isStartingDate: Bool) {
        toolBar.sizeToFit()
        self.isStartingDate = isStartingDate
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                         target: nil,
                                         action: #selector(doneButtonTapped))
        toolBar.setItems([doneButton], animated: true)
    }

    private func setupDatePicker() {
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .dateAndTime
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
    }

    @objc func doneButtonTapped() {
        if isStartingDate {
            startingDateTextField.text = dateFormatter.string(from: datePicker.date)
            todo.startingDate = startingDateTextField.text
            view.endEditing(true)
        } else {
            endingDateTextField.text = dateFormatter.string(from: datePicker.date)
            todo.endingDate = endingDateTextField.text
            view.endEditing(true)
        }
    }

    private func makeButtonAction() {
        let saveAction = UIAction { [weak self] _ in
            let alert = UIAlertController(title: "Unsaved Changes",
                                          message: "Do you want to save your changes?",
                                          preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Yes", style: .default) { [weak self] _ in
                guard let self = self else { return }
                Task {
                    await self.interactor?.setTodoDB(context: self.context, item: self.todo)
                }
                navigationController?.popViewController(animated: true)
            })

            alert.addAction(UIAlertAction(title: "No", style: .cancel) { _ in
                self?.navigationController?.popViewController(animated: true)
            })

            self?.present(alert, animated: true, completion: nil)
        }

        saveButton.addAction(saveAction, for: .touchUpInside)
    }
}

extension NewTaskViewController: IInteractorableController {
    typealias Interactor = INewTaskInteractor
}

extension NewTaskViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case startingDateTextField:
            createToolbar(isStartingDate: true)
        case endingDateTextField:
            createToolbar(isStartingDate: false)
        default:
            print("Fatal")
        }
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case titleTextField:
            todo.todo = textField.text
        case descriptionTextField:
            todo.team = textField.text
        default:
            print("Fatal")
        }
    }
}

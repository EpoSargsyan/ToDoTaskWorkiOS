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
    private var context = CoreDataManager.shared.context

    var interactor: Interactor?

    private var todo: ToDoItemCoreData!

    private let titleLabel = UILabel(text: "New Task",
                                     textColor: .black,
                                     font: UIFont.systemFont(ofSize: 24))

    private let saveButton = UIButton(type: .system)

    private let titleTextField = LargeInputField(labelText: "Title",
                                                 placeholder: "Your ToDo...")
    private let descriptionTextField = TextField(placeholder: "Team name...")

    private let datePicker = UIDatePicker()
    private var dateFormatter = DateFormatter()

    private let startingDateTextField = TextField(placeholder: "Starting date")
    private let endingDateTextField = TextField(placeholder: "Ending date")

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

        view.addSubview(titleLabel)
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

        startingDateTextField.isUserInteractionEnabled = true
        startingDateTextField.inputAccessoryView = toolBar
        startingDateTextField.inputView = datePicker

        endingDateTextField.isUserInteractionEnabled = true
        endingDateTextField.inputAccessoryView = toolBar
        endingDateTextField.inputView = datePicker

        titleTextField.textView.delegate = self
        descriptionTextField.delegate = self
        startingDateTextField.delegate = self
        endingDateTextField.delegate = self

        setupDatePicker()
        setupContraints()
    }

    override func setupInteractor() {
        super.setupInteractor()
    }

    private func setupContraints() {
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(60)
        }

        saveButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
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
            guard let self = self else { return }
            let alert = UIAlertController(title: "Unsaved Changes",
                                          message: "Do you want to save your changes?",
                                          preferredStyle: .alert)

            let saveChanges = UIAlertAction(title: "Yes", style: .default) { _ in
                self.interactor?.saveChanges(context: self.context)
                self.navigationController?.popViewController(animated: true)
            }

            let discardChanges = UIAlertAction(title: "No", style: .cancel) { _ in
                self.navigationController?.popViewController(animated: true)
            }

            alert.addAction(saveChanges)
            alert.addAction(discardChanges)

            self.present(alert, animated: true, completion: nil)
        }

        saveButton.addAction(saveAction, for: .touchUpInside)
    }
}

extension NewTaskViewController: IInteractorableController {
    typealias Interactor = INewTaskInteractor
}

extension NewTaskViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        todo.todo = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

extension NewTaskViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case startingDateTextField:
            createToolbar(isStartingDate: true)
        case endingDateTextField:
            createToolbar(isStartingDate: false)
        default:
            print("Nope")
        }
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == descriptionTextField {
            todo.team = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        descriptionTextField.resignFirstResponder()
        return true
    }
}

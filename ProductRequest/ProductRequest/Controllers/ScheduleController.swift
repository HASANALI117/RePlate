//
//  ScheduleController.swift
//  ProductRequest
//
//  Created by wael on 23/12/2025.
//

import UIKit

class ScheduleController: UIViewController {

    @IBOutlet weak var ConfirmView: RoundedButton!
    @IBOutlet weak var pickersStack: UIStackView!
    
    @IBOutlet weak var finalDateTime: UILabel!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!

    private let datePicker = UIDatePicker()
    private let timePicker = UIDatePicker()
    
    private var isDateSelected = false
    private var isTimeSelected = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPickers()
    }

    // MARK: - Setup
    private func setupPickers() {
        // Date Picker
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        dateTextField.inputView = datePicker
        dateTextField.inputAccessoryView = createToolbar(isDate: true)

        // Time Picker
        timePicker.datePickerMode = .time
        timePicker.preferredDatePickerStyle = .wheels
        timeTextField.inputView = timePicker
        timeTextField.inputAccessoryView = createToolbar(isDate: false)
    }

    private func createToolbar(isDate: Bool) -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let cancel = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: self,
            action: isDate ? #selector(cancelDate) : #selector(cancelTime)
        )

        let flexible = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )

        let done = UIBarButtonItem(
            title: "Done",
            style: .done,
            target: self,
            action: isDate ? #selector(doneDate) : #selector(doneTime)
        )

        toolbar.items = [cancel, flexible, done]
        return toolbar
    }

    // MARK: - Actions
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func selectDateClicked(_ sender: Any) {
        dateTextField.becomeFirstResponder()
    }

    @IBAction func selectTimeClicked(_ sender: Any) {
        timeTextField.becomeFirstResponder()
    }

    @objc private func doneDate() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        dateTextField.text = formatter.string(from: datePicker.date)
        isDateSelected = true
        dateTextField.resignFirstResponder()
    }

    @objc private func doneTime() {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        timeTextField.text = formatter.string(from: timePicker.date)
        isTimeSelected = true
        timeTextField.resignFirstResponder()
    }

    @objc private func cancelDate() {
        dateTextField.resignFirstResponder()
    }

    @objc private func cancelTime() {
        timeTextField.resignFirstResponder()
    }
    
    @IBAction func OkayConfirm(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func ConfirmClicked(_ sender: Any) {

        guard isDateSelected, isTimeSelected else {
            showAlert(
                title: "Missing Information",
                message: "Please select both a pickup date and pickup time."
            )
            return
        }

        let calendar = Calendar.current
        let finalDate = calendar.date(
            bySettingHour: calendar.component(.hour, from: timePicker.date),
            minute: calendar.component(.minute, from: timePicker.date),
            second: 0,
            of: datePicker.date
        )

        print("Final Scheduled DateTime:", finalDate ?? "Invalid")
        self.finalDateTime.text = "Your pickup is scheduled at: \(finalDate ?? Date())"
        self.pickersStack.isHidden = true
        self.ConfirmView.isHidden = false
    }

    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    
}

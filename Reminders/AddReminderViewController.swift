//
//  AddReminderViewController.swift
//  Reminders
//
//  Created by Herlina Astari on 03/03/19.
//  Copyright © 2019 Herlina Astari. All rights reserved.
//

import UIKit
import UserNotifications

class AddReminderViewController: UIViewController {

    var reminder: Reminder?
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleTextField.delegate = self
        self.checkTitle()
        self.timePicker.minimumDate = Date()
        self.timePicker.locale = NSLocale.current
    }
    
    private func checkTitle() {
        let text = titleTextField.text ?? ""
        self.saveButton.isEnabled = !text.isEmpty
    }
    
    private func checkDate() {
        let inputedDate = self.timePicker.date
        let dateNow = Date()
        
        if dateNow > inputedDate {
            self.saveButton.isEnabled = false
        }
    }
    
    @IBAction func timePickerDidChange(_ sender: Any) {
        self.checkDate()
    }
    
    @IBAction func cancelButtonDidClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if self.saveButton === sender as AnyObject? {
            let title = self.titleTextField.text ?? ""
            let time = self.timePicker.date
            
            let notification = UNUserNotificationCenter.current()
            notification.requestAuthorization(options: [.alert, .sound]) { (isGranted, error) in }
            self.reminder = Reminder(title: title, time: time, notification: notification)
        }
    }
    
}

extension AddReminderViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.checkTitle()
        self.navigationItem.title = textField.text
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.saveButton.isEnabled = false
    }
    
}

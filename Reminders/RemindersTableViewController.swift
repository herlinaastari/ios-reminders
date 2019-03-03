//
//  RemindersTableViewController.swift
//  Reminders
//
//  Created by Herlina Astari on 03/03/19.
//  Copyright © 2019 Herlina Astari. All rights reserved.
//

import UIKit

class RemindersTableViewController: UITableViewController {
    
    var reminders = [Reminder]()
    let dateFormatter = DateFormatter()
    let locale = NSLocale.current
    let archiveURL = Reminder.ArchiveURL
    @IBOutlet weak var reminderTitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTableView()
        self.setUpDateFormatter()
        
        if let savedReminders = loadReminders() {
            self.reminders += savedReminders
        }
        self.tableView.reloadData()
    }
    
    private func setupTableView() {
        self.tableView.tableFooterView = UIView()
    }
    
    private func setUpDateFormatter() {
        self.dateFormatter.locale = self.locale
        self.dateFormatter.dateStyle = .medium
        self.dateFormatter.timeStyle = .short
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.reminders.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderTableViewCell", for: indexPath)
        guard indexPath.row < self.reminders.count else { return cell }
        let reminder = reminders[indexPath.row]
        cell.textLabel?.text = reminder.title
        cell.detailTextLabel?.text = "Due " + dateFormatter.string(from: reminder.time ?? Date())
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.reminders.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.saveReminders()
        } else if editingStyle == .insert {
            
        }
    }
    
    func saveReminders() {
        guard let archivePath = self.archiveURL else { return }
        do {
            let reminderData = try NSKeyedArchiver.archivedData(withRootObject: self.reminders, requiringSecureCoding: false)
            try reminderData.write(to: archivePath)
        } catch {
        }
    }
    
    func loadReminders() -> [Reminder]? {
        guard let archiveURL = self.archiveURL else { return nil }
        do {
            let rawData = try Data(contentsOf: archiveURL)
            if let archivedReminders = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(rawData) as? [Reminder] {
                return archivedReminders
            }
            return nil
        } catch {
            return nil
        }
    }
    
    @IBAction func unwindToReminders(sender: UIStoryboardSegue) {
        if let sourceView = sender.source as? AddReminderViewController, let reminder = sourceView.reminder {
            let newIndexPath = IndexPath(row: self.reminders.count, section: 0)
            self.reminders.append(reminder)
            self.tableView.insertRows(at: [newIndexPath], with: .bottom)
            self.saveReminders()
            self.tableView.reloadData()
        }
    }
}

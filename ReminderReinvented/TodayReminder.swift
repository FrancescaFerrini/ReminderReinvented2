//
//  TodayReminder.swift
//  ReminderReinvented
//
//  Created by Francesca Ferrini on 29/03/24.
//

import UIKit

//Variables for reminders with current date
class ReminderTableViewCell: UITableViewCell {
    @IBOutlet weak var notesLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var hour: UILabel!
    
}


class TodayReminder: UIViewController,  UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var reminders: [[String: String]] = []
    var todayReminders: [[String: String]] = []
  
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadReminders()
        printUserDefaultsArray()
        
    }
    
    func loadReminders() {
        // Clean up the memo array before loading new data
        reminders.removeAll()
        
        
        let currentDate = Date()
        
        // Format the date to compare with the date of the reminders
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        // If there are saved reminders, filter reminders by current date
        if let savedReminders = UserDefaults.standard.array(forKey: "reminders") as? [[String: String]] {
            for reminder in savedReminders {
                // Checks whether the date of the memo matches the current date
                if let dateString = reminder["date"],
                   let reminderDate = dateFormatter.date(from: dateString),
                   Calendar.current.isDate(reminderDate, inSameDayAs: currentDate) {
                    // If the date matches, add the reminder to the array
                    reminders.append(reminder)
                }
            }
            
           
        }
        // Reloads the table with filtered reminders
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderCell", for: indexPath) as! ReminderTableViewCell
        
           
        let reminder = reminders[indexPath.row]
           cell.titleLabel.text = reminder["title"]
           cell.notesLabel.text = reminder["notes"]
           cell.dateLabel.text = reminder["date"]
           
           if let time = reminder["time"], time != "chosenTime" {
               cell.timeLabel.text = time
               cell.hour.isHidden = false
               cell.timeLabel.isHidden = false
           } else {
               
               cell.hour.isHidden = true
               cell.timeLabel.isHidden = true
           }
        cell.contentView.frame.inset(by: UIEdgeInsets(top: 250, left: 0, bottom: 250, right: 0))
        cell.contentView.layer.cornerRadius = 20
        cell.contentView.clipsToBounds = true
        
        return cell
    }
        func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func printUserDefaultsArray() {
        if let reminders = UserDefaults.standard.array(forKey: "reminders") as? [[String: String]] {
            print("Contenuto dell'array in UserDefaults:")
            for reminder in reminders {
                if let title = reminder["title"],
                   let notes = reminder["notes"],
                   let date = reminder["date"],
                   let time = reminder["time"] {
                    print("Title: \(title), Notes: \(notes), Date: \(date), Time: \(time)")
                }
            }
        } else {
            print("Nessun promemoria salvato in UserDefaults.")
        }
    }
    
///this method synchronizes the deletion of a reminder between two different views
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Get the selected reminder
            let currentReminder = reminders[indexPath.row]
            
            // Search for the corresponding reminder in the ViewController
            if let viewControllerReminders = UserDefaults.standard.array(forKey: "reminders") as? [[String: String]] {
                for (index, viewControllerReminder) in viewControllerReminders.enumerated() {
                    // Checks whether reminders have the same fields filled in
                    if currentReminder == viewControllerReminder {
                        // Remove the reminder from the array of the ViewController
                        var mutableViewControllerReminders = viewControllerReminders
                        mutableViewControllerReminders.remove(at: index)
                        UserDefaults.standard.set(mutableViewControllerReminders, forKey: "reminders")
                        let saved = UserDefaults.standard.synchronize()
                        if saved {
                            print("Promemoria eliminato correttamente dalla ViewController.")
                        } else {
                            print("Errore nell'eliminazione del promemoria dalla ViewController.")
                        }
                        
                        // Remove the reminder from the TodayReminder
                        reminders.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .automatic)
                        print("Promemoria eliminato correttamente dalla TodayReminder.")
                        return
                    }
                }
            }
            
            // If a matching reminder is not found, it shows an error message
            print("Nessun promemoria corrispondente trovato nella ViewController.")
        }
    }

///this function filters out reminders that are valid for the current day.
    func isCurrentDateReminder(indexPath: IndexPath) -> Bool {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        if let dateString = reminders[indexPath.row]["date"],
           let reminderDate = dateFormatter.date(from: dateString),
           Calendar.current.isDate(reminderDate, inSameDayAs: currentDate) {
            return true
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            
            return 165 
        }
    

    
    func printReminders() {
        if let reminders = UserDefaults.standard.array(forKey: "reminders") as? [[String: String]] {
            for reminder in reminders {
                if let title = reminder["title"],
                   let notes = reminder["notes"],
                   let date = reminder["date"],
                   let time = reminder["time"] {
                    print("Title: \(title), Notes: \(notes), Date: \(date), Time: \(time)")
                }
            }
        } else {
            print("Nessun promemoria salvato")
        }
    }
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: {
            NotificationCenter.default.post(name: Notification.Name("ReloadData"), object: nil)
        })
    }
    
 ///this function is executed when the view is about to disappear from the user's view. During this time, a notification is sent via NotificationCenter with the name "ReloadData," indicating to reload the data to update the reminder view .
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
     
            NotificationCenter.default.post(name: Notification.Name("ReloadData"), object: nil)
    }
}

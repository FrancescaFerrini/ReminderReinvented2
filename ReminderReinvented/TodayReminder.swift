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
    
    @IBOutlet weak var container: UIView!
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
           return reminders.count + reminders.count
       }
    
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           // Check if it's an even row index
           if indexPath.row % 2 == 0 {
               // If it's an even row index, display a reminder cell
               let reminderIndex = indexPath.row / 2
               let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderCell", for: indexPath) as! ReminderTableViewCell
               let reminder = reminders[reminderIndex]
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
               
               // Apply corner radius and clipping to the content view
               cell.contentView.layer.cornerRadius = 20
               cell.contentView.clipsToBounds = true
               
               return cell
           } else {
               // If it's an odd row index, display an empty cell
               let cell = UITableViewCell()
               cell.backgroundColor = tableView.backgroundColor
               cell.selectionStyle = .none
               return cell
           }
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
    ///this method synchronizes the deletion of a reminder between two different views
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                // If the row index is even, it is a reminder and we can delete it
                if indexPath.row % 2 == 0 {
                    let reminderIndex = indexPath.row / 2
                    
                    
                    let removedReminder = reminders.remove(at: reminderIndex)
                    
                    // Remove the reminder also from UserDefaults
                    if var userDefaultsReminders = UserDefaults.standard.array(forKey: "reminders") as? [[String: String]] {
                        if let index = userDefaultsReminders.firstIndex(where: { $0 == removedReminder }) {
                            userDefaultsReminders.remove(at: index)
                            UserDefaults.standard.set(userDefaultsReminders, forKey: "reminders")
                        }
                    }
                    
                    // Also remove the blank line after the reminder
                    let emptyCellIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
                    tableView.beginUpdates()
                    tableView.deleteRows(at: [indexPath, emptyCellIndexPath], with: .automatic)
                    tableView.endUpdates()
                    
                    print("Promemoria eliminato correttamente.")
                } else {
                    // If the row index is odd, it is an empty cell and do nothing
                    print("Riga dispari, non è possibile eliminare.")
                }
            }
        }


///this function filters out reminders that are valid for the current day.
 
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
                
            if indexPath.row % 2 != 0 {
                  // Set a small height for the empty cells
                  return 5 // You can adjust this value as needed
              } else {
                  // Use automatic dimension for reminder cells
                  return UITableView.automaticDimension
              }
            }
        
    

    
    func addReminder(_ reminder: [String: String]) {
        // Add the reminder to the array
        reminders.append(reminder)
        
        // Update the table view
        let indexPath = IndexPath(row: reminders.count * 2 - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
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
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Allow swipe only on even rows, which correspond to reminders
        return indexPath.row % 2 == 0
    }

}

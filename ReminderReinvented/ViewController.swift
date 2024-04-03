//
//  ViewController.swift
//  ReminderReinvented
//
//  Created by Francesca Ferrini on 24/03/24.
//

import UIKit


class AllReminderViewCell: UITableViewCell{
    //Variables for expired reminders
    @IBOutlet weak var allTitle: UILabel!
    @IBOutlet weak var allNote: UILabel!
    @IBOutlet weak var allDate: UILabel!
    @IBOutlet weak var allHour: UILabel!
    @IBOutlet weak var allTime: UILabel!
}

class MainReminderViewCell: UITableViewCell{
    //Variables for the next days' reminders
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var note: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var hour: UILabel!
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    
    
    //Variables of the main view
    @IBOutlet weak var expiredLabel: UILabel!
    @IBOutlet weak var followingDays: UILabel!
    @IBOutlet weak var closeDay: UILabel!
    @IBOutlet weak var completeReminders: UILabel!
    @IBOutlet weak var reminderNumber: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var todayDate: UILabel!
    @IBOutlet weak var cardOfTheDay: UIView!
    @IBOutlet weak var outlineTodayDate: UIView!
    @IBOutlet weak var backgroundPlusButton: UIView!
    @IBOutlet weak var tableView1: UITableView!
    @IBOutlet weak var tableView2: UITableView!
    @IBOutlet weak var numberRemindersPresent: UIButton!
    let dateFormatter = DateFormatter()
    var reminders: [[String: String]] = []
    @IBOutlet weak var transparentBlur: UIView!
    var blurView: UIVisualEffectView?
    
    
///this function initializes the ViewController view, sets the tables, loads the reminders, configures the graphical appearance, and registers the observer for any updates to the reminder data.
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView1.delegate = self
        tableView1.dataSource = self
        tableView2.delegate = self
        tableView2.dataSource = self
        loadReminders()
        recoveredString()
        setupView()
        //this code registers the ViewController as an observer for the "ReloadData" notification. When this notification is published to the NotificationCenter, the ViewController's reloadData() method will be called
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: Notification.Name("ReloadData"), object: nil)
            }
    
///graphic setup of the main view
    func setupView(){
      
        self.cardOfTheDay.layer.cornerRadius = 20
        self.outlineTodayDate.layer.cornerRadius = 20
        self.tableView1.layer.cornerRadius = 20
        self.tableView2.layer.cornerRadius = 20
        
        //Show the current date in the mainview
        let date = Date()
        let formatter = DateFormatter()
        formatter.timeZone = .current
        //formatter.dateStyle = .short
        formatter.locale = .current
        formatter.dateFormat = "MMMM d"
        todayDate.text = formatter.string(from: date)
        
        //Shadow of the card
        self.cardOfTheDay.layer.shadowColor = UIColor.systemGreen.cgColor
        self.cardOfTheDay.layer.shadowOpacity = 0.5
        self.cardOfTheDay.layer.shadowOffset = .zero
        self.cardOfTheDay.layer.shadowRadius = 10
        
       // Creating a transparent blur effect
        let blurEffect = UIBlurEffect(style: .light)
        let customBlurEffectView = UIVisualEffectView(effect: blurEffect)
        customBlurEffectView.frame = backgroundPlusButton.bounds
        customBlurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundPlusButton.layer.cornerRadius = 20
        
        
        let customBlurEffectView1 = UIVisualEffectView(effect: blurEffect)
        customBlurEffectView1.frame = transparentBlur.bounds
        customBlurEffectView1.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundPlusButton.clipsToBounds = true
      
        // Set the corner radius only for your UIView
        // Add the blurred background effect behind your UIView
        backgroundPlusButton.insertSubview(customBlurEffectView, at: 0)
        
        
        blurView = UIVisualEffectView(effect: blurEffect)
        
        blurView?.removeFromSuperview()
        let maskPath = UIBezierPath(roundedRect: transparentBlur.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: 25, height: 25))
               let maskLayer = CAShapeLayer()
               maskLayer.frame = transparentBlur.bounds
               maskLayer.path = maskPath.cgPath
               blurView?.layer.mask = maskLayer
        
        // Set the corner radius only for your UIView
        transparentBlur.layer.cornerRadius = 20
        transparentBlur.clipsToBounds = true
        
        // Add the blurred background effect behind your UIView
        transparentBlur.insertSubview(customBlurEffectView1, at: 0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        let todayReminders = reminders.filter { reminder in
            guard let dateString = reminder["date"],
                  let reminderDate = dateFormatter.date(from: dateString) else {
                return false
            }
            return Calendar.current.isDate(reminderDate, inSameDayAs: currentDate)
        }
        
        
        // Update the text of the reminderNumber label.
        reminderNumber.text = "\(todayReminders.count) reminders"
        return reminders.count
    }
    
    @IBAction func editButtonAction(_ sender: Any) {
        self.tableView1.isEditing = !self.tableView1.isEditing
        self.tableView2.isEditing = !self.tableView2.isEditing
        editButton.setTitle((self.tableView1.isEditing || self.tableView2.isEditing) ? "Done" : "Edit", for: .normal)
    }
    
///function to reload data when a specific notification is received, while deinit ensures that the view controller instance stops observing notifications when it is deallocated.
    @objc func reloadData() {
        loadReminders()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
///this function deals with the creation and configuration of cells for the two tables in the view. It uses two custom cell types (MainReminderViewCell and AllReminderViewCell) to display reminder data according to the specified table.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if tableView == tableView1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderCell12", for: indexPath) as! MainReminderViewCell
            
            let reminder = reminders[indexPath.row]
            cell.title.text = reminder["title"]
            cell.note.text = reminder["notes"]
            cell.date.text = reminder["date"]
            
            if let time = reminder["time"], time != "chosenTime" {
                cell.time.text = time
                cell.hour.isHidden = false
                cell.time.isHidden = false
            } else {
                // Hide the time label if it is equal to the default string
                cell.hour.isHidden = true
                cell.time.isHidden = true
            }
            // Configure the cell for tableView1
            cell.contentView.layer.cornerRadius = 20
            cell.contentView.clipsToBounds = true
            return cell
            
        } else if tableView == tableView2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderCell2", for: indexPath) as! AllReminderViewCell
            
            let reminder = reminders[indexPath.row]
            cell.allTitle.text = reminder["title"]
            cell.allNote.text = reminder["notes"]
            cell.allDate.text = reminder["date"]
            
            if let time = reminder["time"], time != "chosenTime" {
                cell.allTime.text = time
                cell.allHour.isHidden = false
                cell.allTime.isHidden = false
            } else {
                // Hide the time label if it is equal to the default string
                cell.allHour.isHidden = true
                cell.allTime.isHidden = true
            }
            // Configure the cell for tableView2
            cell.contentView.frame.inset(by: UIEdgeInsets(top: 250, left: 0, bottom: 250, right: 0))
            cell.contentView.layer.cornerRadius = 20
            cell.contentView.clipsToBounds = true
            
            return cell
        }
        return UITableViewCell()
    }
   
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
///Loads saved reminders from UserDefaults and updates the tables
    func loadReminders() {
        if let savedReminders = UserDefaults.standard.array(forKey: "reminders") as? [[String: String]] {
            reminders = savedReminders
            tableView1.reloadData()
            tableView2.reloadData()
        }
    }
    
///this function handles the deletion of a reminder from the table, array, and persistent storage when the user performs the delete action on a row in the table.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Remove the reminder from the array only if it comes from the corresponding view
            if tableView == tableView1 || tableView == tableView2 {
                reminders.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                UserDefaults.standard.set(reminders, forKey: "reminders")
                if reminders.isEmpty {
                    UserDefaults.standard.removeObject(forKey: "reminders")
                }
                let saved = UserDefaults.standard.synchronize()
                if saved {
                    print("Dati salvati correttamente.")
                } else {
                    print("Errore nel salvataggio dei dati.")
                }
            }
            tableView1.reloadData()
            tableView2.reloadData()
        }
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
    
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
///updating the order of the elements in the reminders array when the user moves rows within the table
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let moveObjTemp = reminders[sourceIndexPath.item]
        reminders.remove(at: sourceIndexPath.item)
        reminders.insert(moveObjTemp, at: destinationIndexPath.item)
    }
    
   
///this function checks the date of the reminder and returns a different height depending on whether the reminder is before, after, or equal to the current date, thus ensuring that only valid reminders are displayed in the table.
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //the desired height for the cells
        if tableView == tableView1 {
            let currentDate = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            
            if let dateString = reminders[indexPath.row]["date"],
               let reminderDate = dateFormatter.date(from: dateString),
               reminderDate > Calendar.current.startOfDay(for: currentDate)  {
                return 180
            }
            return 0
        }
        
        if tableView == tableView2 {
            let currentDate = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            
            if let dateString = reminders[indexPath.row]["date"],
               let reminderDate = dateFormatter.date(from: dateString),
               reminderDate < Calendar.current.startOfDay(for: currentDate) {
                return 180
            }
            return 0
        }
        return 180 // Hide the cell if the date is invalid
        
    }
    
///useful for debugging and checking whether reminders have been properly saved and retrieved.
    func recoveredString(){
        
        if let reminders = UserDefaults.standard.array(forKey: "reminders") as? [[String: String]] {
            for reminder in reminders {
                if let title = reminder["title"],
                   let notes = reminder["notes"],
                   let date = reminder["date"],
                   let time = reminder["time"] {
                    print("Title: \(title), Notes: \(notes), Date: \(date), Time: \(time)")
                    print("-------")
                }
            }
        } else {
            print("Nessun promemoria salvato")
        }
    }
    
    
    @IBAction func addReminder(_ sender: Any) {
        print("addReminder clicked")
    }
    
    @IBAction func editReminders(_ sender: Any) {
        print("editReminders clicked")
    }
    
    func emptyReminders(){
        if UserDefaults.standard.object(forKey: "reminders") == nil {
            followingDays.isHidden = true
            expiredLabel.isHidden = true
        } else {
            followingDays.isHidden = false
            expiredLabel.isHidden = false
        }
    }
}




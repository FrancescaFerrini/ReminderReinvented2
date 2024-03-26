//
//  ViewController.swift
//  ReminderReinvented
//
//  Created by Francesca Ferrini on 24/03/24.
//

import UIKit

class ViewController: UIViewController {

   
//VARIABILI
    @IBOutlet weak var all: UILabel!
    @IBOutlet weak var followingDays: UILabel!
    @IBOutlet weak var closeDay: UILabel!
    @IBOutlet weak var completeReminders: UILabel!
    @IBOutlet weak var reminderNumber: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var todayDate: UILabel!
    @IBOutlet weak var cardOfTheDay: UIView!
    @IBOutlet weak var outlineTodayDate: UIView!
    @IBOutlet weak var backgroundPlusButton: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cardOfTheDay.layer.cornerRadius = 20
        self.outlineTodayDate.layer.cornerRadius = 20
        self.backgroundPlusButton.layer.cornerRadius = 20
        
        
        //
        let date = Date()
        let formatter = DateFormatter()
        formatter.timeZone = .current
        //formatter.dateStyle = .short
        formatter.locale = .current
        formatter.dateFormat = "MMMM d"
        todayDate.text = formatter.string(from: date)
        
        
        
    }

   
    @IBAction func addReminder(_ sender: Any) {
        print("addReminder clicked")
    }
    
    @IBAction func editReminders(_ sender: Any) {
        print("editReminders clicked")
    }
}


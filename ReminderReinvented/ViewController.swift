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
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }

   
    @IBAction func addReminder(_ sender: Any) {
        print("addReminder clicked")
    }
    
    @IBAction func editReminders(_ sender: Any) {
        print("editReminders clicked")
    }
}


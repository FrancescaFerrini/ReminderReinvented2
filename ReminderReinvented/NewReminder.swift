//
//  ViewController.swift
//  save
//
//  Created by Francesca Ferrini on 28/03/24.
//

//
//  NewReminder.swift
//  ReminderReinvented
//
//  Created by Francesca Ferrini on 25/03/24.
//
import UIKit

class NewReminder: UIViewController, UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate,UIPickerViewDelegate, UITextFieldDelegate   {
    
    
    //Variables for the view and for creating new reminders
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cellContainingTheDate: UIButton!
    @IBOutlet weak var titleNewReminder: UITextField!
    @IBOutlet weak var notesNewReminder: UITextField!
    @IBOutlet weak var toggleDataPicker: UISwitch!
    @IBOutlet weak var chosenDate: UILabel!
    @IBOutlet weak var cellContainingTheTime: UIButton!
    @IBOutlet weak var toggleTime: UISwitch!
    @IBOutlet weak var chosenTime: UILabel!
    
    let addCalendar = UICalendarView()
    let addPicker = UIDatePicker()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleNewReminder.layer.cornerRadius = 20
        self.notesNewReminder.layer.cornerRadius = 20
        
        cellContainingTheDate.layer.borderWidth = 0.5
        cellContainingTheDate.layer.borderColor = UIColor.systemGray4.cgColor
        cellContainingTheDate.layer.cornerRadius = 5
        
        cellContainingTheTime.layer.borderWidth = 0.5
        cellContainingTheTime.layer.borderColor = UIColor.systemGray4.cgColor
        cellContainingTheTime.layer.cornerRadius = 5
        
        addPicker.addTarget(self, action: #selector(timeChanged), for: .valueChanged)
        
        
        chosenDate.isHidden = true
        chosenTime.isHidden = true
        saveButton.isEnabled = false
        
        
        titleNewReminder.delegate = self
        notesNewReminder.delegate = self
        
        upDateSaveButtonState()
        
        
    }
    func upDateSaveButtonState() {
        let defaultDateText = "chosenDate"
        
        if let titleText = titleNewReminder.text, !titleText.isEmpty,
           let notesText = notesNewReminder.text, !notesText.isEmpty,
           chosenDate.text != defaultDateText {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
    
    
    func createCalendar(){
        
        addCalendar.translatesAutoresizingMaskIntoConstraints = false
        let dataSelector = UICalendarSelectionSingleDate(delegate: self)
        addCalendar.selectionBehavior = dataSelector
        
        addCalendar.calendar = .current
        addCalendar.locale = .current
        addCalendar.fontDesign = .rounded
        addCalendar.layer.cornerRadius = 12
        addCalendar.backgroundColor = .white
        addCalendar.delegate = self
        
        
        view.addSubview(addCalendar)
        
        NSLayoutConstraint.activate([
            addCalendar.topAnchor.constraint(equalTo: cellContainingTheDate.topAnchor, constant: 45), // Spazio dalla parte superiore della calendarView
            addCalendar.leadingAnchor.constraint(equalTo: cellContainingTheDate.leadingAnchor, constant: 8), // Spazio dalla parte sinistra della calendarView
            addCalendar.trailingAnchor.constraint(equalTo: cellContainingTheDate.trailingAnchor, constant: -8), // Spazio dalla parte destra della calendarView
            
            
        ])
    }
    
    func removeCalendar(){
        
        addCalendar.removeFromSuperview()
    }
    
    func createPicker(){
        addPicker.translatesAutoresizingMaskIntoConstraints = false
        addPicker.datePickerMode = .countDownTimer
        addCalendar.delegate = self
        
        addPicker.layer.borderWidth = 0.5
        addPicker.layer.borderColor = UIColor.systemGray5.cgColor
        addPicker.layer.cornerRadius = 5
        addPicker.backgroundColor = UIColor.white
        
        
        view.addSubview(addPicker)
        
        NSLayoutConstraint.activate([
            addPicker.topAnchor.constraint(equalTo: cellContainingTheTime.topAnchor, constant: 45), // Spazio dalla parte superiore della calendarView
            addPicker.leadingAnchor.constraint(equalTo: cellContainingTheTime.leadingAnchor, constant: 8), // Spazio dalla parte sinistra della calendarView
            addPicker.trailingAnchor.constraint(equalTo: cellContainingTheTime.trailingAnchor, constant: -8) // Spazio dalla parte destra della calendarView
            
        ])
        
    }
    func removePicker(){
        addPicker.removeFromSuperview()
    }
    
   
///Data saving function
    @IBAction func saveButton_NewReminderAdded(_ sender: Any) {
        // Ottenere i valori dalle text field
        let title = titleNewReminder.text ?? ""
        let notes = notesNewReminder.text ?? ""
        let date = chosenDate.text ?? ""
        let time = chosenTime.text ?? ""
        
        
        

        
        print("Valori salvati con successo")
        saveReminder(title: title, notes: notes, date: date, time: time)
        printReminders()
        
        dismiss(animated: true, completion: {
            NotificationCenter.default.post(name: Notification.Name("ReloadData"), object: nil)
        })
        
    }
    
    @IBAction func cancelButton_NewReminderAdded(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func toggleDataPickerChanged(_ sender: UISwitch) {
        if sender.isOn{
            createCalendar()
            upDateSaveButtonState()
        }else {
            chosenDate.text = ""
            chosenDate.isHidden = true
            upDateSaveButtonState()
            
            
        }
    }
    
    
    @IBAction func toggleTimePickerChanged(_ sender: UISwitch) {
        if sender.isOn{
            timeChanged()
            createPicker()
        }else{
            chosenTime.text = ""
            chosenTime.isHidden = true
        }
    }
    
    
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        guard let dateComponents = dateComponents,
              let date = Calendar.current.date(from: dateComponents) else {
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let formattedDate = dateFormatter.string(from: date)
        chosenDate.text = formattedDate
        chosenDate.isHidden = false
        upDateSaveButtonState()
       
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        upDateSaveButtonState()
        return true
    }
    
    
    
    
    @IBAction func pressCellCloseCalendar(_ sender: Any) {
        print("calendar closed")
        removeCalendar()
        toggleDataPicker.isOn = true
        upDateSaveButtonState()
    }
    
    @IBAction func pressCellCloseTime(_ sender: Any) {
        print("time closed")
        removePicker()
        toggleTime.isOn = true
    }
    
    @objc func timeChanged() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let formattedTime = dateFormatter.string(from: addPicker.date)
        chosenTime.text = formattedTime
        chosenTime.isHidden = false
        
    }
    
///Create and save the updated list of reminders in the application data store using UserDefaults.standard.set(reminders, forKey: "reminders").
    func saveReminder(title: String, notes: String, date: String, time: String){
        var reminders = UserDefaults.standard.array(forKey: "reminders") as? [[String: String]] ?? []
        let reminder = ["title": title, "notes": notes, "date": date, "time": time]
            reminders.append(reminder)
        
        UserDefaults.standard.set(reminders, forKey: "reminders")
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
    
}




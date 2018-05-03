//
//  AddEventViewController.swift
//  JNTSeniorProjectXCode
//
//  Created by Tom, Jack, and Natalie on 2/25/18.
//  Copyright © 2018 Tom, Jack, and Natalie. All rights reserved.
//

import UIKit
import os.log
import JTAppleCalendar
import UserNotifications

class AddEventViewController: UIViewController, UITextFieldDelegate {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTextField.delegate = self
        descriptionTextField.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
        myDatePicker.isHidden = true
        myDatePicker.minimumDate = Date()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // END DEFAULT FUNCTIONS
    
    
    // Outlets from AddEvent Storyboard
    
    // Bad Name, this button adds the task to the Calendar. MAY CHANGE THESE BAD NAMES LATER
    @IBOutlet weak var testButton: UIButton!
    
    // The date picker that pops up. Visibility set to False by default.
    @IBOutlet weak var myDatePicker: UIDatePicker!
    
    // Bad Name, this label shows the date after it's been picked using myDatePicker.
    @IBOutlet weak var testLabel: UILabel!
    
    // TextField for users to put a title for event
    @IBOutlet weak var titleTextField: UITextField!
    
    // TextField for users to put a description for the event.
    @IBOutlet weak var descriptionTextField: UITextField!
    
    // Button that will make the date picker appear.
    @IBOutlet weak var selectDateButton: UIButton!
    
    // Button to cancel adding an event
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var PriorityChooser: UISegmentedControl!
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.titleTextField.resignFirstResponder()
        
        self.descriptionTextField.resignFirstResponder()
        
        return true
    }
    
    
    
    
    
    // Other needed variables
    
    var userTitle: String? = ""
    
    var userDescription: String?
    
    var userPriority: Int? = 3
    

    
    
    //Notification manager
    let notificationCenter = UNUserNotificationCenter.current()
    let options: UNAuthorizationOptions = [.badge, .alert, .sound];
    
    
    @IBAction func cancelPopover(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func bringUpDatePicker(_ sender: Any) {
        view.endEditing(true)
        myDatePicker.isHidden = false
    }
    
    
    @IBAction func titleTextFieldChanged(_ sender: Any) {
        userTitle = titleTextField.text!
    }
    
    
    @IBAction func descriptionTextFieldChanged(_ sender: Any) {
        userDescription = descriptionTextField.text!
    }
    
    //Choose the Priority
    
    @IBAction func PickPriority(_ sender: Any) {
        
        if PriorityChooser.selectedSegmentIndex == 2
        {
            userPriority = 1
        }
        else if PriorityChooser.selectedSegmentIndex == 1
        {
            userPriority = 2
        }
        else if PriorityChooser.selectedSegmentIndex == 0
        {
            userPriority = 3
        }
        else
        {
            userPriority = 3
        }
    }
    
    // Add the Event to the Calendar
    @IBAction func buttonPressed(_ sender: Any) {
        
        
        let myDateFormatter = DateFormatter()
        let myLocale = NSLocale.autoupdatingCurrent;
        
        myDateFormatter.locale = myLocale
        
        myDateFormatter.dateFormat = "yyyy MM dd"
        
        
        
        if(userTitle == "" || userTitle == nil){
            // Standard alert from Apple's website
            let missingTitleAlert = UIAlertController(title: "No Title", message: "Please add a title", preferredStyle: .alert)
            missingTitleAlert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            self.present(missingTitleAlert, animated: true, completion: nil)
        }
        else{
            
            if (userDescription == nil || userDescription == ""){
                userDescription = " "
            }
            
            self.dismiss(animated: true, completion: nil)            
            
            //Create an event object, that will take in the users info for said event
            let EventTaskObject = TaskObject(taskDate: myDatePicker.date, taskTitle: userTitle!, taskDescription: userDescription!, taskPriority: userPriority!, taskMadeDate: Date())
            EventTaskObject.taskDate = myDatePicker.date
            EventTaskObject.taskTitle = userTitle
            EventTaskObject.taskDescription = userDescription
            EventTaskObject.taskPriority = userPriority
            EventTaskObject.taskMadeDate = Date()
            
            //If there is already an event for that day's key, add said event into event array. If no event lists on that day, create the array
            if var keyDate = TaskObjectDic.taskDic[myDateFormatter.string(from: myDatePicker.date)]
            {
                keyDate.append(EventTaskObject)
                TaskObjectDic.taskDic[myDateFormatter.string(from: myDatePicker.date)] = keyDate
            } else {
                TaskObjectDic.taskDic[myDateFormatter.string(from: myDatePicker.date)] = [EventTaskObject]
            }
            
            //To store the data, we must first encode our dictionary with the key "eventDic"
            let uDefault = UserDefaults.standard
            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: TaskObjectDic.taskDic)
            
            uDefault.set(encodedData, forKey: "eventDic")
            addedEvent.added = true
            updatedTask.updatedt = true
            
            reminders()
        
        }
        
        
    }
    
    func reminders(){
        
        let myDateFormatter = DateFormatter()
        let myLocale = NSLocale.autoupdatingCurrent;
        
        myDateFormatter.locale = myLocale
        
        myDateFormatter.dateFormat = "yyyy MM dd HH mm ss SSSS"
        
        notificationCenter.requestAuthorization(options: options) {
            (granted, error) in
            if !granted {
                print("Something went wrong")
            }
        }
        
        notificationCenter.getNotificationSettings { (settings) in
            if settings.authorizationStatus != .authorized {
                // Notifications not allowed
            }
        }
        
        var trigger:UNNotificationTrigger
        
        let content = UNMutableNotificationContent()
        content.title = userTitle!
        content.body = userDescription!
        content.sound = UNNotificationSound.default()
        
        var daysDouble = (round(myDatePicker.date.timeIntervalSinceNow/86400))
        if daysDouble <= 0{
            daysDouble = 1 
        }
        
        
        var triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second], from: Date())
        triggerDate.hour = 9
        triggerDate.minute = 30
        triggerDate.second = 00
        var eventDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second], from: myDatePicker.date)
        eventDate.hour = 9
        eventDate.minute = 30
        eventDate.second = 00
        
        var fixedArray:Array<Int> = []

        
        if myDatePicker.date.timeIntervalSinceNow > 604800.00 {
            if userPriority == 1
            {
                let days = Int(daysDouble/2)

                for i in 1...days
                {
                    triggerDate.day! += 2
                    
                    //running a function to check if the days surpassed the month, then updating the month
                    fixedArray = dateFixer(day: triggerDate.day!, month: triggerDate.month!)
                    triggerDate.day = fixedArray[1]
                    triggerDate.month = fixedArray[0]
                    
                    if (triggerDate.month! >= eventDate.month! && triggerDate.day! >= eventDate.day!)
                    {
                        trigger = UNCalendarNotificationTrigger(dateMatching: eventDate, repeats: false)
                    }else{
                        trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
                    }
                    let highPriId = (myDateFormatter.string(from: myDatePicker.date) + "\(i)")
                    let highPrReq = UNNotificationRequest(identifier: highPriId, content: content, trigger: trigger)
                    notificationCenter.add(highPrReq, withCompletionHandler: {(error) in
                        if let highPriError = error {
                            //something went wrong
                        }
                    })
                }
            }
            else if userPriority == 2
            {
                let days = Int(daysDouble/3)
                for i in 1...days
                {
                    triggerDate.day! += 3

                    fixedArray = dateFixer(day: triggerDate.day!, month: triggerDate.month!)
                    triggerDate.day = fixedArray[1]
                    triggerDate.month = fixedArray[0]
                    
                    if (triggerDate.month! >= eventDate.month! && triggerDate.day! >= eventDate.day!)
                    {
                        trigger = UNCalendarNotificationTrigger(dateMatching: eventDate, repeats: false)
                    }else{
                        trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
                    }
                    let medPriId = (myDateFormatter.string(from: myDatePicker.date) + "\(i)")
                    let medPrReq = UNNotificationRequest(identifier: medPriId, content: content, trigger: trigger)
                    notificationCenter.add(medPrReq, withCompletionHandler: {(error) in
                        if let medPriError = error {
                            //something went wrong
                        }
                    })
                }
            }
            else if userPriority == 3
            {
                let days = Int(daysDouble/4)
                for i in 1...days
                {
                    triggerDate.day! += 4

                    fixedArray = dateFixer(day: triggerDate.day!, month: triggerDate.month!)
                    triggerDate.day = fixedArray[1]
                    triggerDate.month = fixedArray[0]
                    
                    if (triggerDate.month! >= eventDate.month! && triggerDate.day! >= eventDate.day!)
                    {
                        trigger = UNCalendarNotificationTrigger(dateMatching: eventDate, repeats: false)
                    }else{
                        trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
                    }
                    let lowPriId = (myDateFormatter.string(from: myDatePicker.date) + "\(i)")
                    let lowPrReq = UNNotificationRequest(identifier: lowPriId, content: content, trigger: trigger)
                    notificationCenter.add(lowPrReq, withCompletionHandler: {(error) in
                        if let lowPriError = error {
                            //something went wrong
                        }
                    })
                }
            }
        }else{
            let days = Int(daysDouble)
            for i in 1...days
            {
                triggerDate.day! += 1
                
                fixedArray = dateFixer(day: triggerDate.day!, month: triggerDate.month!)
                triggerDate.day = fixedArray[1]
                triggerDate.month = fixedArray[0]
                
                if (triggerDate.month! >= eventDate.month! && triggerDate.day! >= eventDate.day!)
                {
                    trigger = UNCalendarNotificationTrigger(dateMatching: eventDate, repeats: false)
                }else{
                    trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
                }
                let lowPriId = (myDateFormatter.string(from: myDatePicker.date) + "\(i)")
                let lowPrReq = UNNotificationRequest(identifier: lowPriId, content: content, trigger: trigger)
                notificationCenter.add(lowPrReq, withCompletionHandler: {(error) in
                    if let lowPriError = error {
                        //something went wrong
                    }
                })
            }
            
        }
    }
    
    func dateFixer(day: Int,month: Int) -> Array<Int>
    {
        var nDay = day
        var nMonth = month
        if month == 12
        {
            if day > 31
            {
                nDay = day - 31
                nMonth = 1
            }
        }else if month == 11
        {
            if day > 30
            {
                nDay = day - 30
                nMonth = 12
            }
            
        }else if month == 10
        {
            if day > 31
            {
                nDay = day - 31
                nMonth = 11
            }
            
        }else if month == 9
        {
            if day > 30
            {
                nDay = day - 30
                nMonth = 10
            }
            
        }else if month == 8
        {
            if day > 31
            {
                nDay = day - 31
                nMonth = 9
            }
            
        }else if month == 7
        {
            if day > 31
            {
                nDay = day - 31
                nMonth = 8
            }
            
        }else if month == 6
        {
            if day > 30
            {
                nDay = day - 30
                nMonth = 7
            }
            
        }else if month == 5
        {
            if day > 31
            {
                nDay = day - 31
                nMonth = 6
            }
            
        }else if month == 4
        {
            if day > 30
            {
                nDay = day - 30
                nMonth = 5
            }
            
        }else if month == 3
        {
            if day > 31
            {
                nDay = day - 31
                nMonth = 4
            }
            
        }else if month == 2
        {
            if day > 28
            {
                nDay = day - 28
                nMonth = 3
            }
            
        }else if month == 1
        {
            if day > 31
            {
                nDay = day - 31
                nMonth = 2
            }
        }
        
        return [nMonth,nDay]
    }
    
    
}

struct addedEvent
{
    static var added = false
}



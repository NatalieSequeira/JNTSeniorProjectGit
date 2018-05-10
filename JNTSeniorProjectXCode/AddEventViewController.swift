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

class AddEventViewController: UIViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        myDatePicker.isHidden = true
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
    
    
    @IBOutlet weak var PriorityChooser: UISegmentedControl!
    
    
    
    
    // Other needed variables
    
    var userTitle: String? = ""
    
    var userDescription: String?
    
    var userPriority: Int? = 3
    
    
    //Notification manager
    let notificationCenter = UNUserNotificationCenter.current()
    let options: UNAuthorizationOptions = [.badge, .alert, .sound];
    
    
    
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
            let EventTaskObject = TaskObject(taskDate: myDatePicker.date, taskTitle: userTitle!, taskDescription: userDescription!, taskPriority: userPriority!)
            EventTaskObject.taskDate = myDatePicker.date
            EventTaskObject.taskTitle = userTitle
            EventTaskObject.taskDescription = userDescription
            EventTaskObject.taskPriority = userPriority
            
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
        
        myDateFormatter.dateFormat = "yyyy MM dd"
        
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
       /* var dateComponents = DateComponents()
        dateComponents.hour = 10
        dateComponents.minute = 30
        trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)*/
        
        let content = UNMutableNotificationContent()
        content.title = userTitle!
        content.body = userDescription!
        content.sound = UNNotificationSound.default()
        
        let daysDouble = (round(myDatePicker.date.timeIntervalSinceNow/86400))
        
        var triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second], from: Date())
        triggerDate.hour = 9
        triggerDate.minute = 30
        var eventDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second], from: myDatePicker.date)
        eventDate.hour = 9
        eventDate.minute = 30

        
        if myDatePicker.date.timeIntervalSinceNow > 345600.00 {
            if userPriority == 1
            {
                let days = Int(daysDouble/2)

                for i in 1...days
                {
                    triggerDate.day! += 2
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
            else if userPriority == 3
            {
                let days = Int(daysDouble/4)
                for i in 1...days
                {
                    triggerDate.day! += 4
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
        }
        
        
       /* let identifier = "UYLLocalNotification"
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content, trigger: trigger)
        notificationCenter.add(request, withCompletionHandler: { (error) in
            if let error = error {
                // Something went wrong
            }
        })*/
        
        
    }
    
    
}

struct addedEvent
{
    static var added = false
}



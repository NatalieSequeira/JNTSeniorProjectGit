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
        
        //Initializing variables to be used in textfields and the datepicker
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
    //@IBOutlet weak var testLabel: UILabel!
    
    // TextField for users to put a title for event
    @IBOutlet weak var titleTextField: UITextField!
    
    // TextField for users to put a description for the event.
    @IBOutlet weak var descriptionTextField: UITextField!
    
    // Button that will make the date picker appear.
    @IBOutlet weak var selectDateButton: UIButton!
    
    // Button to cancel adding an event
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var PriorityChooser: UISegmentedControl!
    
    //Function to dismiss the keyboard when the return key is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.titleTextField.resignFirstResponder()
        
        self.descriptionTextField.resignFirstResponder()
        
        return true
    }//end function
    
    
    
    
    
    // Other needed variables
    
    var userTitle: String? = ""
    
    var userDescription: String?
    
    var userPriority: Int? = 3
    

    
    
    //Notification manager
    let notificationCenter = UNUserNotificationCenter.current()
    let options: UNAuthorizationOptions = [.badge, .alert, .sound];
    
    //Function to dismiss the screen if user decides not to add an event
    @IBAction func cancelPopover(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }//end function
    
    //function to present the date picker
    @IBAction func bringUpDatePicker(_ sender: Any) {
        view.endEditing(true)
        myDatePicker.isHidden = false
    }//end function
    
    //function to store the text field once text is added
    @IBAction func titleTextFieldChanged(_ sender: Any) {
        userTitle = titleTextField.text!
    }//end function
    
    //function to store the text field once text is added
    @IBAction func descriptionTextFieldChanged(_ sender: Any) {
        userDescription = descriptionTextField.text!
    }//end function
    
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
    }//end function
    
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
            
            //if there is no text replace it with a space
            if (userDescription == nil || userDescription == ""){
                userDescription = " "
            }//end if
            
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
            }//end if
            
            //To store the data, we must first encode our dictionary with the key "eventDic"
            let uDefault = UserDefaults.standard
            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: TaskObjectDic.taskDic)
            
            uDefault.set(encodedData, forKey: "eventDic")
            
            reminders()
        
        }
        
        
    }//end function
    
    //function to create notifications
    func reminders(){
        
        let myDateFormatter = DateFormatter()
        let myLocale = NSLocale.autoupdatingCurrent;
        
        myDateFormatter.locale = myLocale
        
        myDateFormatter.dateFormat = "M-dd"
        
        //get permission to send notifications
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
        
        //begin construction the base notification
        var trigger:UNNotificationTrigger
        
        //set the content of the notification to the event title and description
        let content = UNMutableNotificationContent()
        content.title = ("\(userTitle!) | Due: \(myDateFormatter.string(from: myDatePicker.date))")
        content.body = userDescription!
        content.sound = UNNotificationSound.default()
        
        myDateFormatter.dateFormat = "yyyy MM dd HH mm ss SSSS"
        
        //get how many days between now and the event date
        var daysDouble = (round(myDatePicker.date.timeIntervalSinceNow/86400))
        if daysDouble <= 0{
            daysDouble = 1 
        }
        
        
        //set the trigger date to today
        var triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second], from: Date())
        triggerDate.hour = 9
        triggerDate.minute = 30
        triggerDate.second = 00
        var eventDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second], from: myDatePicker.date)
        eventDate.hour = 9
        eventDate.minute = 30
        eventDate.second = 00
        
        var fixedArray:Array<Int> = []

        // if the event is more than a week out, notifiy them based off priorities
        if myDatePicker.date.timeIntervalSinceNow > 604800.00 {
            //check if high priority
            if userPriority == 1
            {
                //find how how many events to send
                let days = Int(daysDouble/2)

                //for said events, add one every two days
                for i in 1...days
                {
                    triggerDate.day! += 2
                    
                    //running a function to check if the days surpassed the month, then update the month
                    fixedArray = dateFixer(day: triggerDate.day!, month: triggerDate.month!)
                    triggerDate.day = fixedArray[1]
                    triggerDate.month = fixedArray[0]
                    
                    //check to see if the trigger date has surpassed the event day
                    if (triggerDate.month! >= eventDate.month! && triggerDate.day! >= eventDate.day!)
                    {
                        trigger = UNCalendarNotificationTrigger(dateMatching: eventDate, repeats: false)
                    }else{
                        trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
                    }//end if
                    let highPriId = (myDateFormatter.string(from: myDatePicker.date) + "\(i)")
                    let highPrReq = UNNotificationRequest(identifier: highPriId, content: content, trigger: trigger)
                    notificationCenter.add(highPrReq, withCompletionHandler: {(error) in
                        if let highPriError = error {
                            //something went wrong
                        }
                    })
                }//end for
            }//end if
            //check if medium priority
            else if userPriority == 2
            {
                //find how how many events to send
                let days = Int(daysDouble/3)
                //for said events, add one every three days
                for i in 1...days
                {
                    triggerDate.day! += 3

                    //running a function to check if the days surpassed the month, then update the month
                    fixedArray = dateFixer(day: triggerDate.day!, month: triggerDate.month!)
                    triggerDate.day = fixedArray[1]
                    triggerDate.month = fixedArray[0]
                    
                    //check to see if the trigger date has surpassed the event day
                    if (triggerDate.month! >= eventDate.month! && triggerDate.day! >= eventDate.day!)
                    {
                        trigger = UNCalendarNotificationTrigger(dateMatching: eventDate, repeats: false)
                    }else{
                        trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
                    }//end if
                    let medPriId = (myDateFormatter.string(from: myDatePicker.date) + "\(i)")
                    let medPrReq = UNNotificationRequest(identifier: medPriId, content: content, trigger: trigger)
                    notificationCenter.add(medPrReq, withCompletionHandler: {(error) in
                        if let medPriError = error {
                            //something went wrong
                        }
                    })
                }//end for
            }//end if
            //check if low priority
            else if userPriority == 3
            {
                //find out how many events to send
                let days = Int(daysDouble/4)
                //for said events, add one every four days
                for i in 1...days
                {
                    triggerDate.day! += 4

                    fixedArray = dateFixer(day: triggerDate.day!, month: triggerDate.month!)
                    triggerDate.day = fixedArray[1]
                    triggerDate.month = fixedArray[0]
                    
                    //check to see if the trigger date has surpassed the event day
                    if (triggerDate.month! >= eventDate.month! && triggerDate.day! >= eventDate.day!)
                    {
                        trigger = UNCalendarNotificationTrigger(dateMatching: eventDate, repeats: false)
                    }else{
                        trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
                    }//end if
                    let lowPriId = (myDateFormatter.string(from: myDatePicker.date) + "\(i)")
                    let lowPrReq = UNNotificationRequest(identifier: lowPriId, content: content, trigger: trigger)
                    notificationCenter.add(lowPrReq, withCompletionHandler: {(error) in
                        if let lowPriError = error {
                            //something went wrong
                        }
                    })
                }//end for
            }//end if
            
        //if the event is less than a week out, remind every day
        }else{
            //find how many events to create
            let days = Int(daysDouble)
            //for said events, make one every day
            for i in 1...days
            {
                triggerDate.day! += 1
                
                //fix dates if passing a month
                fixedArray = dateFixer(day: triggerDate.day!, month: triggerDate.month!)
                triggerDate.day = fixedArray[1]
                triggerDate.month = fixedArray[0]
                
                //check to see if the trigger date has surpassed the event day
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
            }//end for
            
        }//end if
    }//end func
    
    //func to check if a date passed a month
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
    }//end func
    
    
}




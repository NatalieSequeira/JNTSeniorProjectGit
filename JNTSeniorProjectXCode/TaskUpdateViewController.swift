//
//  TaskUpdateViewController.swift
//  JNTSeniorProjectXCode
//
//  Created by Thomas Zorn on 4/19/18.
//  Copyright © 2018 Tom, Jack, and Natalie. All rights reserved.
//

import UIKit
import UserNotifications

class TaskUpdateViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var updateTitleField: UITextField!
    @IBOutlet weak var updateDescriptionField: UITextField!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var updateButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateTitleField.delegate = self
        updateDescriptionField.delegate = self
        
        //Struct.dictionary[key] gives you the array, we then access the index at [struct.index], then retrieve the task title/description
        updateTitleField.placeholder = ("Title: \(TaskObjectDic.taskDic[dateKey.key]![modifiedIndex.index].taskTitle!)")
        
        updateDescriptionField.placeholder = ("Description: \(TaskObjectDic.taskDic[dateKey.key]![modifiedIndex.index].taskDescription!)")

        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.updateTitleField.resignFirstResponder()
        
        self.updateDescriptionField.resignFirstResponder()
        
        return true
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var updatedTitle: String?
    var updatedDescription: String?
    
    @IBAction func cancelPopover(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func updateTitleFieldChanged(_ sender: Any) {
        if (updateTitleField.text != nil){
            updatedTitle = updateTitleField.text!
        }else{
            updatedTitle = TaskObjectDic.taskDic[dateKey.key]![modifiedIndex.index].taskTitle
        }
    }
    
    @IBAction func updateDescriptionFieldChanged(_ sender: Any) {
        if (updateDescriptionField.text != nil){
            updatedDescription = updateDescriptionField.text!
        }else{
            updatedDescription = TaskObjectDic.taskDic[dateKey.key]![modifiedIndex.index].taskDescription
        }
    }
    
    @IBAction func updateComplete(_ sender: Any) {
        
        if updatedTitle != nil {
            TaskObjectDic.taskDic[dateKey.key]![modifiedIndex.index].taskTitle = updatedTitle
        }else{
            updatedTitle = TaskObjectDic.taskDic[dateKey.key]![modifiedIndex.index].taskTitle
        }

        if updatedDescription != nil {
            TaskObjectDic.taskDic[dateKey.key]![modifiedIndex.index].taskDescription = updatedDescription
        }else{
            updatedDescription = TaskObjectDic.taskDic[dateKey.key]![modifiedIndex.index].taskDescription

        }
        
    
        //notifications
        let notificationCenter = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.badge, .alert, .sound];
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
       
        let madeDate = TaskObjectDic.taskDic[dateKey.key]![modifiedIndex.index].taskMadeDate!
        let fireDate = TaskObjectDic.taskDic[dateKey.key]![modifiedIndex.index].taskDate!
        
        
        let deleteDatesDouble = (round(fireDate.timeIntervalSince(madeDate)/86400))
        
        var deleteDates = Int(deleteDatesDouble)
        
        if fireDate.timeIntervalSince(madeDate) > 604800.00
        {
            if TaskObjectDic.taskDic[dateKey.key]![modifiedIndex.index].taskPriority == 1
            {
                deleteDates = Int(deleteDatesDouble/2)
            }else if TaskObjectDic.taskDic[dateKey.key]![modifiedIndex.index].taskPriority == 2
            {
                deleteDates = Int(deleteDatesDouble/3)
            }else if TaskObjectDic.taskDic[dateKey.key]![modifiedIndex.index].taskPriority == 3
            {
                deleteDates = Int(deleteDatesDouble/4)
            }
        }
        
        if (deleteDates > 0){
            for i in 1...deleteDates
            {
                notificationCenter.removePendingNotificationRequests(withIdentifiers: ([myDateFormatter.string(from: fireDate) + "\(i)"]) )
            }
        }
        
        
        
        
        
        var trigger:UNNotificationTrigger
        
        myDateFormatter.dateFormat = "MM-dd"

        
        let content = UNMutableNotificationContent()
        content.title = ("\(updatedTitle!) | Due: \(myDateFormatter.string(from: TaskObjectDic.taskDic[dateKey.key]![modifiedIndex.index].taskDate))")
        content.body = updatedDescription!
        content.sound = UNNotificationSound.default()
        
        var daysDouble = (round(TaskObjectDic.taskDic[dateKey.key]![modifiedIndex.index].taskDate.timeIntervalSinceNow/86400))
        
        if daysDouble <= 0
        {daysDouble = 1}
        
        var triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second], from: Date())
        triggerDate.hour = 9
        triggerDate.minute = 30
        triggerDate.second = 00
        var eventDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second], from: TaskObjectDic.taskDic[dateKey.key]![modifiedIndex.index].taskDate)
        eventDate.hour = 9
        eventDate.minute = 30
        eventDate.second = 00
        
        var fixedArray:Array<Int> = []
        
        if fireDate.timeIntervalSinceNow > 604800.00 {
            if TaskObjectDic.taskDic[dateKey.key]![modifiedIndex.index].taskPriority == 1
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
                    let highPriId = (myDateFormatter.string(from: fireDate) + "\(i)")
                    let highPrReq = UNNotificationRequest(identifier: highPriId, content: content, trigger: trigger)
                    notificationCenter.add(highPrReq, withCompletionHandler: {(error) in
                        if let highPriError = error {
                            //something went wrong
                        }
                    })
                }
            }
            else if TaskObjectDic.taskDic[dateKey.key]![modifiedIndex.index].taskPriority == 2
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
                    let medPriId = (myDateFormatter.string(from: fireDate) + "\(i)")
                    let medPrReq = UNNotificationRequest(identifier: medPriId, content: content, trigger: trigger)
                    notificationCenter.add(medPrReq, withCompletionHandler: {(error) in
                        if let medPriError = error {
                            //something went wrong
                        }
                    })
                }
            }
            else if TaskObjectDic.taskDic[dateKey.key]![modifiedIndex.index].taskPriority == 3
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
                    let lowPriId = (myDateFormatter.string(from: fireDate) + "\(i)")
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
                let lowPriId = (myDateFormatter.string(from: fireDate) + "\(i)")
                let lowPrReq = UNNotificationRequest(identifier: lowPriId, content: content, trigger: trigger)
                notificationCenter.add(lowPrReq, withCompletionHandler: {(error) in
                    if let lowPriError = error {
                        //something went wrong
                    }
                })
            }
            
        }
        
        



        
        let uDefault = UserDefaults.standard
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: TaskObjectDic.taskDic)
        
        uDefault.set(encodedData, forKey: "eventDic")
        self.dismiss(animated: true, completion: nil)
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


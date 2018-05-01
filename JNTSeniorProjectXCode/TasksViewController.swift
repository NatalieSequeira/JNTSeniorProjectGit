//
//  TasksViewController.swift
//  
//
//  Created by Thomas Zorn on 3/28/18.
//

import UIKit
import UserNotifications

class TasksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    
    var keyArray:Array<String> = []
    var taskArray:Array<TaskObject> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        
        //var colorTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateColor), userInfo: nil, repeats: true)
        
       //When the app launchs, we will check for a dictionary, if there is one, we will fetch it
        if (UserDefaults.standard.object(forKey: "eventDic") == nil){
            print("FirstLoad")
        } else {
        let decoded = UserDefaults.standard.object(forKey: "eventDic") as! Data

        TaskObjectDic.taskDic = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [String : Array<TaskObject>]
        }
        
        keyArray = Array(TaskObjectDic.taskDic.keys)
        
        for key in keyArray
        {
            if TaskObjectDic.taskDic[key]?.count == 0
            {
                let index = keyArray.index(of: key)
                keyArray.remove(at: index!)
            }
        }
        
        let myDateFormatter = DateFormatter()
        let myLocale = NSLocale.autoupdatingCurrent;
        
        myDateFormatter.locale = myLocale
        
        myDateFormatter.dateFormat = "yyyy MM dd"
        
        var convertArray:[Date] = []
        
        for dat in keyArray
        {
            let nDate = myDateFormatter.date(from: dat)
            if let nDate = nDate{
                convertArray.append(nDate)
            }
        }
        
        keyArray.removeAll()
        convertArray = convertArray.sorted(by: { $0.compare($1) == .orderedDescending })
        
        for sDat in convertArray
        {
            let sDate = myDateFormatter.string(from: sDat)
            keyArray.append(sDate)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    /*@objc func updateColor()
    {
        self.tableView.reloadData()
    }*/
    
    @objc func update()
    {
        if (updatedTask.updatedt)
        {
            keyArray = Array(TaskObjectDic.taskDic.keys)
            for key in keyArray
            {
                if TaskObjectDic.taskDic[key]?.count == 0
                {
                    let index = keyArray.index(of: key)
                    keyArray.remove(at: index!)
                }
            }
            
            let myDateFormatter = DateFormatter()
            let myLocale = NSLocale.autoupdatingCurrent;
            
            myDateFormatter.locale = myLocale
            
            myDateFormatter.dateFormat = "yyyy MM dd"
            
            var convertArray:[Date] = []
            
            for dat in keyArray
            {
                let nDate = myDateFormatter.date(from: dat)
                if let nDate = nDate{
                    convertArray.append(nDate)
                }
            }
            
            keyArray.removeAll()
            convertArray = convertArray.sorted(by: { $0.compare($1) == .orderedDescending })
            
            for sDat in convertArray
            {
                let sDate = myDateFormatter.string(from: sDat)
                keyArray.append(sDate)
            }
            
            self.tableView.reloadData()
            updatedTask.updatedt = false
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return keyArray.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return keyArray[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TaskObjectDic.taskDic[keyArray[section]]!.count
        }
    
    /*func handleCellColor(tableView: UITableView){
        let indexPath: IndexPath
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TaskTableViewCell

        if taskArray[indexPath.row].taskPriority == 2
        {
            cell.backgroundColor = .yellow
        }
        else if taskArray[indexPath.row].taskPriority == 1
        {
            cell.backgroundColor = .red
        }
    }*/
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TaskTableViewCell
        
        taskArray = TaskObjectDic.taskDic[keyArray[indexPath.section]]!
        
        let text = taskArray[indexPath.row].taskTitle
        
        if taskArray[indexPath.row].taskPriority == 2
        {
            cell.backgroundColor = .yellow
        }
        else if taskArray[indexPath.row].taskPriority == 1
        {
            cell.backgroundColor = .red
        }
        
        cell.taskTitleLabel.text = text
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TaskTableViewCell
        
        taskArray = TaskObjectDic.taskDic[keyArray[indexPath.section]]!
        
        if taskArray[indexPath.row].taskPriority == 2
        {
            cell.backgroundColor = .yellow
        }
        else if taskArray[indexPath.row].taskPriority == 1
        {
            cell.backgroundColor = .red
        }
        
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TaskTableViewCell
        
        taskArray = TaskObjectDic.taskDic[keyArray[indexPath.section]]!
        
        if taskArray[indexPath.row].taskPriority == 2
        {
            cell.backgroundColor = .yellow
        }
        else if taskArray[indexPath.row].taskPriority == 1
        {
            cell.backgroundColor = .red
        }
    }
    
    
    //Select Cell to read description
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        taskArray = TaskObjectDic.taskDic[keyArray[indexPath.section]]!
        
        if taskArray[indexPath.row].taskDescription != " "{
            let descriptionAlert = UIAlertController(title: "Description", message: taskArray[indexPath.row].taskDescription, preferredStyle: .alert)
            descriptionAlert.addAction(UIAlertAction(title: NSLocalizedString("Close", comment: "Default action"), style: .`default`, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            self.present(descriptionAlert, animated: true, completion: nil)
        }
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        taskArray = TaskObjectDic.taskDic[keyArray[indexPath.section]]!
        
        let modify = UITableViewRowAction(style: .normal, title: "Edit") { action, xindex in
            //print("Modify button tapped")
            
            modifiedIndex.index = indexPath.row
            dateKey.key = self.keyArray[indexPath.section]
            
            let popoverContent = self.storyboard?.instantiateViewController(withIdentifier: "Task Update View Controller") as UIViewController?
            let navigation = UINavigationController(rootViewController: popoverContent!)
            navigation.modalPresentationStyle = UIModalPresentationStyle.popover
            let popover = navigation.popoverPresentationController
            popover?.delegate = self as? UIPopoverPresentationControllerDelegate
            popover?.sourceView = self.view
            
            self.present(navigation, animated: true, completion: nil)
            self.taskArray =  TaskObjectDic.taskDic[self.keyArray[indexPath.section]]!
            
            tableView.reloadData()
            
        }
        modify.backgroundColor = .lightGray
        
        
        let delete = UITableViewRowAction(style: .destructive, title: "Complete") { action, index in
            
            
            updatedTask.updatedt = true
            addedEvent.added = true
            
            let notificationCenter = UNUserNotificationCenter.current()
            let options: UNAuthorizationOptions = [.badge, .alert, .sound];
            let myDateFormatter = DateFormatter()
            let myLocale = NSLocale.autoupdatingCurrent;
            
            myDateFormatter.locale = myLocale
            
            myDateFormatter.dateFormat = "yyyy MM dd HH mm ss SSSS"
            
            //remove notificaitons for it
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
            
            let madeDate = TaskObjectDic.taskDic[self.keyArray[indexPath.section]]![indexPath.row].taskMadeDate!
            let fireDate = TaskObjectDic.taskDic[self.keyArray[indexPath.section]]![indexPath.row].taskDate!
            
            
            let deleteDatesDouble = (round(fireDate.timeIntervalSince(madeDate)/86400))
            
            var deleteDates = Int(deleteDatesDouble)
            
            if deleteDates <= 0
            {deleteDates = 1}
            
            if fireDate.timeIntervalSince(madeDate) > 604800.00
            {
                if TaskObjectDic.taskDic[self.keyArray[indexPath.section]]![indexPath.row].taskPriority == 1
                {
                    deleteDates = Int(deleteDatesDouble/2)
                }else if TaskObjectDic.taskDic[self.keyArray[indexPath.section]]![indexPath.row].taskPriority == 2
                {
                    deleteDates = Int(deleteDatesDouble/3)
                }else if TaskObjectDic.taskDic[self.keyArray[indexPath.section]]![indexPath.row].taskPriority == 3
                {
                    deleteDates = Int(deleteDatesDouble/4)
                }
            }
            
            for i in 1...deleteDates
            {
                notificationCenter.removePendingNotificationRequests(withIdentifiers: ([myDateFormatter.string(from: fireDate) + "\(i)"]) )
            }

            /*Remove the event from the array, then override the value in the
             dictionary for the key, which is the day we're in */
            self.taskArray.remove(at: indexPath.row)
            TaskObjectDic.taskDic.updateValue(self.taskArray, forKey: self.keyArray[indexPath.section])
            
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            
            //Encode and store the new dictionary, which has the new array.
            let uDefault = UserDefaults.standard
            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: TaskObjectDic.taskDic)
            
            uDefault.set(encodedData, forKey: "eventDic")
            
        }
        delete.backgroundColor = .green
        
        
        return [delete, modify]
    }
    

    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
 
    }
}

struct updatedTask
{
    static var updatedt = false
}


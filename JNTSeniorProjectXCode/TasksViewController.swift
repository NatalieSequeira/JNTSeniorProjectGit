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
    
    //bool to see if an event has been updated
    var updateBool = true

    //an array to hold the keys of the dictionary
    var keyArray:Array<String> = []
    //an array to hold the tasks of a day
    var taskArray:Array<TaskObject> = []
    
    //colors to be used for the priorites
    let highPriCol = UIColor(red: 255, green: 73/255, blue: 73/255, alpha: 0.95)
    let medPriCol = UIColor(red: 255, green: 243/255, blue: 117/255, alpha: 0.95)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       //When the app launchs, we will check for a dictionary, if there is one, we will fetch it
        if (UserDefaults.standard.object(forKey: "eventDic") == nil){
            print("FirstLoad")
        } else {
        let decoded = UserDefaults.standard.object(forKey: "eventDic") as! Data

        TaskObjectDic.taskDic = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [String : Array<TaskObject>]
        }
        
        //set the key array to the current dictionaries keys
        keyArray = Array(TaskObjectDic.taskDic.keys)
        
        //for loop to remove keys if there is no longer events on that day
        for key in keyArray
        {
            if TaskObjectDic.taskDic[key]?.count == 0
            {
                let index = keyArray.index(of: key)
                keyArray.remove(at: index!)
            }
        }//end for
        
        let myDateFormatter = DateFormatter()
        let myLocale = NSLocale.autoupdatingCurrent;
        
        myDateFormatter.locale = myLocale
        
        myDateFormatter.dateFormat = "yyyy MM dd"
        
        var convertArray:[Date] = []
        
        //for loop to make an array of date objects to be sorted
        for dat in keyArray
        {
            let nDate = myDateFormatter.date(from: dat)
            if let nDate = nDate{
                convertArray.append(nDate)
            }
        }//end for
        
        //empty the key array to be sorted
        keyArray.removeAll()
        
        //sort the date array
        convertArray = convertArray.sorted(by: { $0.compare($1) == .orderedAscending })
        
        //for loop to enter the sorted keys into the key array
        for sDat in convertArray
        {
            let sDate = myDateFormatter.string(from: sDat)
            keyArray.append(sDate)
        }//end for
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //Func viewWillappear does the same as view did load, but will reflect changes more than once
 
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
        
        /*for i in 0...tableView.numberOfSections
        {
            if (tableView.numberOfRows(inSection: i) <= 0)
            {
                tableView.deleteSections(IndexSet(integersIn: i...i), with: UITableViewRowAnimation.fade)
                
            }
        }*/
        
        self.tableView.reloadData()
    }
    
    
    //func to determine how many sections are needed
    func numberOfSections(in tableView: UITableView) -> Int {
        return keyArray.count
    }//end func
    
    //func to title each section
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return keyArray[section]
    }//end func
    
    
    //func to determine how many rows a section will need
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TaskObjectDic.taskDic[keyArray[section]]!.count
        }//end func
    
    //func to populate each row with text and a color representing it's priority
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TaskTableViewCell
        
        taskArray = TaskObjectDic.taskDic[keyArray[indexPath.section]]!
        
        let text = taskArray[indexPath.row].taskTitle
        
        if taskArray[indexPath.row].taskPriority == 2
        {
            cell.backgroundColor = medPriCol
        }
        else if taskArray[indexPath.row].taskPriority == 1
        {
            cell.backgroundColor = highPriCol
        }
        
        cell.taskTitleLabel.text = text
        
        return cell
    }//end func
    
    
    //func to ensure a rows text and color remain the same even when off screen
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TaskTableViewCell
        
        taskArray = TaskObjectDic.taskDic[keyArray[indexPath.section]]!
        
        if taskArray[indexPath.row].taskPriority == 2
        {
            cell.backgroundColor = medPriCol
        }
        else if taskArray[indexPath.row].taskPriority == 1
        {
            cell.backgroundColor = highPriCol
        }
        
    }//end func
    
    //func to ensure a rows text and color remain the same even when off screen
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TaskTableViewCell
        
        if(indexPath.section > 0 && keyArray.indices.contains(indexPath.section))
        {
            taskArray = TaskObjectDic.taskDic[keyArray[indexPath.section]]!
            
            if (taskArray.indices.contains(indexPath.row)){
                if taskArray[indexPath.row].taskPriority == 2
                    {
                        cell.backgroundColor = medPriCol
                    }
                    else if taskArray[indexPath.row].taskPriority == 1
                    {
                        cell.backgroundColor = highPriCol
                    }
                }
            }
    }//end func
    
    
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
        
    }//end func
    
    
    //func to handle modify and delete
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        taskArray = TaskObjectDic.taskDic[keyArray[indexPath.section]]!
        
        
        let modify = UITableViewRowAction(style: .normal, title: "Edit") { action, xindex in
            
            //set the modified index to the current row
            modifiedIndex.index = indexPath.row
            
            //set the current datekey to the keyArray at this section
            dateKey.key = self.keyArray[indexPath.section]
            
            //begin a popover to bring up the update view controller to handle updating
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
            
            //set up notification center to delete notifications that have been made for deleted event
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
            
            //check how many events will be made for each priority
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
            }//end if
            
            //delete the events
            for i in 1...deleteDates
            {
                notificationCenter.removePendingNotificationRequests(withIdentifiers: ([myDateFormatter.string(from: fireDate) + "\(i)"]) )
            }//end for

            /*Remove the event from the array, then override the value in the
             dictionary for the key, which is the day we're in */
            self.taskArray.remove(at: indexPath.row)
            TaskObjectDic.taskDic.updateValue(self.taskArray, forKey: self.keyArray[indexPath.section])
            
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            
            //Encode and store the new dictionary, which has the new array.
            let uDefault = UserDefaults.standard
            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: TaskObjectDic.taskDic)
            
            uDefault.set(encodedData, forKey: "eventDic")
            
            self.updateBool = true
            
        }
        delete.backgroundColor = .green
        
        return [delete, modify]
    }//end func
    

    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
 
    }
}



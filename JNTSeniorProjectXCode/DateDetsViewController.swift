//
//  DateDetsViewController.swift
//  JNTSeniorProjectXCode
//
//  Created by Thomas Zorn on 4/2/18.
//  Copyright © 2018 Tom, Jack, and Natalie. All rights reserved.
//

import UIKit
import UserNotifications


class DateDetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var DoneButton: UIButton!
    
    //array to hold tasks
    var taskArray:Array<TaskObject> = []
    //set up colors for priorites
    let highPriCol = UIColor(red: 255, green: 73/255, blue: 73/255, alpha: 0.95)
    let medPriCol = UIColor(red: 255, green: 243/255, blue: 117/255, alpha: 0.95)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set the task array to the array in the dictionary with the specified date key
        taskArray = TaskObjectDic.taskDic[dateKey.key]!
        
        tableView.delegate = self
        tableView.dataSource = self
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }
    
    //set up how many rows are needed
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(taskArray.count)
        return taskArray.count
    }//end func
    
    
    //func to set up each row with text and color
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DateDetsTableViewCell
        
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
    
    //handle the row when not on screen
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DateDetsTableViewCell
        
        if taskArray[indexPath.row].taskPriority == 2
        {
            cell.backgroundColor = medPriCol
        }
        else if taskArray[indexPath.row].taskPriority == 1
        {
            cell.backgroundColor = highPriCol
        }
        
    }//end func
    
    //handle the row when not on screen
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DateDetsTableViewCell
        
        if(indexPath.row > 0 && taskArray.indices.contains(indexPath.row))
        {
            if taskArray[indexPath.row].taskPriority == 2
            {
                cell.backgroundColor = medPriCol
            }
            else if taskArray[indexPath.row].taskPriority == 1
            {
                cell.backgroundColor = highPriCol
            }
        }
    }//end func
    
    
    //Select Cell to read description
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if taskArray[indexPath.row].taskDescription != " "{
            let descriptionAlert = UIAlertController(title: "Description", message: taskArray[indexPath.row].taskDescription, preferredStyle: .alert)
            descriptionAlert.addAction(UIAlertAction(title: NSLocalizedString("Close", comment: "Default action"), style: .`default`, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            self.present(descriptionAlert, animated: true, completion: nil)
        }
        
    }
        
        
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//
    @IBAction func backToCalendar(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Deleting a task from the list. Thanks for a start point, ioscreator.com
    // www.ioscreator.com/tutorials/delete-rows-table-view-ios8-swift
    // Thanks as well to jose920405 for showing editable buttons for the tableview cells!
    // stackoverflow.com/questions/32004557/swipe-able-table-view-cell-in-ios-9
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let modify = UITableViewRowAction(style: .normal, title: "Edit") { action, index in
            //print("Modify button tapped")
            
            //set the modified index struct to the current row
            modifiedIndex.index = indexPath.row
            
            //popover to the task update view controller
            let popoverContent = self.storyboard?.instantiateViewController(withIdentifier: "Task Update View Controller") as UIViewController?
            let navigation = UINavigationController(rootViewController: popoverContent!)
            navigation.modalPresentationStyle = UIModalPresentationStyle.popover
            let popover = navigation.popoverPresentationController
            popover?.delegate = self as? UIPopoverPresentationControllerDelegate
            popover?.sourceView = self.view
            
            self.present(navigation, animated: true, completion: nil)
            self.taskArray =  TaskObjectDic.taskDic[dateKey.key]!
            
            tableView.reloadData()
            
        }
        modify.backgroundColor = .lightGray
        
        
        let delete = UITableViewRowAction(style: .destructive, title: "Complete") { action, index in
            
                        
            //set up notification settings for deleting notifications
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
            
            let madeDate = TaskObjectDic.taskDic[dateKey.key]![indexPath.row].taskMadeDate!
            let fireDate = TaskObjectDic.taskDic[dateKey.key]![indexPath.row].taskDate!
            
            
            let deleteDatesDouble = (round(fireDate.timeIntervalSince(madeDate)/86400))
            
            var deleteDates = Int(deleteDatesDouble)
            
            if deleteDates <= 0
            {deleteDates = 1}
            
            //find out how many events were made in the first place to delete
            if fireDate.timeIntervalSince(madeDate) > 604800.00
            {
                if TaskObjectDic.taskDic[dateKey.key]![indexPath.row].taskPriority == 1
                {
                    deleteDates = Int(deleteDatesDouble/2)
                }else if TaskObjectDic.taskDic[dateKey.key]![indexPath.row].taskPriority == 2
                {
                    deleteDates = Int(deleteDatesDouble/3)
                }else if TaskObjectDic.taskDic[dateKey.key]![indexPath.row].taskPriority == 3
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
            TaskObjectDic.taskDic.updateValue(self.taskArray, forKey: dateKey.key)
            
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            
            //Encode and store the new dictionary, which has the new array.
            let uDefault = UserDefaults.standard
            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: TaskObjectDic.taskDic)
            
            uDefault.set(encodedData, forKey: "eventDic")
            
        }
        delete.backgroundColor = .green
        
        
        return [delete, modify]
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

struct modifiedIndex
{
    static var index:Int!
}

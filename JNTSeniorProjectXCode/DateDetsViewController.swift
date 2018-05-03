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
    
    var taskArray:Array<TaskObject> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        taskArray = TaskObjectDic.taskDic[dateKey.key]!
        
        tableView.delegate = self
        tableView.dataSource = self
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(taskArray.count)
        return taskArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Heyo")

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DateDetsTableViewCell
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DateDetsTableViewCell
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DateDetsTableViewCell
        
        if(indexPath.row > 0 && taskArray.indices.contains(indexPath.row))
        {
            if taskArray[indexPath.row].taskPriority == 2
            {
                cell.backgroundColor = .yellow
            }
            else if taskArray[indexPath.row].taskPriority == 1
            {
                cell.backgroundColor = .red
            }
        }
    }
    
    
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
            
            modifiedIndex.index = indexPath.row
            
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
            
            let madeDate = TaskObjectDic.taskDic[dateKey.key]![indexPath.row].taskMadeDate!
            let fireDate = TaskObjectDic.taskDic[dateKey.key]![indexPath.row].taskDate!
            
            
            let deleteDatesDouble = (round(fireDate.timeIntervalSince(madeDate)/86400))
            
            var deleteDates = Int(deleteDatesDouble)
            
            if deleteDates <= 0
            {deleteDates = 1}
            
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
            }
            
            for i in 1...deleteDates
            {
                notificationCenter.removePendingNotificationRequests(withIdentifiers: ([myDateFormatter.string(from: fireDate) + "\(i)"]) )
            }


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

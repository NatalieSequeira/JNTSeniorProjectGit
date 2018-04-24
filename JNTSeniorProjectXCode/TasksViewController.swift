//
//  TasksViewController.swift
//  
//
//  Created by Thomas Zorn on 3/28/18.
//

import UIKit
class TasksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    
    var keyArray:Array<String> = []
    var taskArray:Array<TaskObject> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         var timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        
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
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
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


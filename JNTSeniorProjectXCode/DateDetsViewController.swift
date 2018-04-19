//
//  DateDetsViewController.swift
//  JNTSeniorProjectXCode
//
//  Created by Thomas Zorn on 4/2/18.
//  Copyright © 2018 Tom, Jack, and Natalie. All rights reserved.
//

import UIKit

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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(taskArray.count)
        return taskArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Heyo")

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DateDetsTableViewCell
        
        let text = taskArray[indexPath.row].taskTitle
        
        cell.taskTitleLabel.text = text
        
        return cell
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
            
        }
        modify.backgroundColor = .lightGray
        
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { action, index in
            
            
            addedEvent.added = true
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
        // more.backgroundColor = .lightGray
        
        
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

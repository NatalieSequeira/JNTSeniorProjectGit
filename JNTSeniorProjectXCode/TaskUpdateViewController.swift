//
//  TaskUpdateViewController.swift
//  JNTSeniorProjectXCode
//
//  Created by Thomas Zorn on 4/19/18.
//  Copyright © 2018 Tom, Jack, and Natalie. All rights reserved.
//

import UIKit

class TaskUpdateViewController: UIViewController {

    
    @IBOutlet weak var updateTitleField: UITextField!
    @IBOutlet weak var updateDescriptionField: UITextField!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var updateButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Struct.dictionary[key] gives you the array, we then access the index at [struct.index], then retrieve the task title/description
        updateTitleField.placeholder = ("Title: \(TaskObjectDic.taskDic[dateKey.key]![modifiedIndex.index].taskTitle!)")
        
        updateDescriptionField.placeholder = ("Description: \(TaskObjectDic.taskDic[dateKey.key]![modifiedIndex.index].taskDescription!)")

        // Do any additional setup after loading the view.
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
        }

        if updatedDescription != nil {
            TaskObjectDic.taskDic[dateKey.key]![modifiedIndex.index].taskDescription = updatedDescription
        }
        
        updatedItem.updated = true
        updatedTask.updatedt = true


        
        let uDefault = UserDefaults.standard
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: TaskObjectDic.taskDic)
        
        uDefault.set(encodedData, forKey: "eventDic")
        self.dismiss(animated: true, completion: nil)
    }
}

struct updatedItem{
    static var updated = false
}

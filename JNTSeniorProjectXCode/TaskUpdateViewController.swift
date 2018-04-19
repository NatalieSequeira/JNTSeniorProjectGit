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
        
        updateTitleField.text = TaskObjectDic.taskDic[dateKey.key]![modifiedIndex.index].taskTitle
        
        updateDescriptionField.text = TaskObjectDic.taskDic[dateKey.key]![modifiedIndex.index].taskDescription

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
        updatedTitle = updateTitleField.text
    }
    
    @IBAction func updateDescriptionFieldChanged(_ sender: Any) {
        updatedDescription = updateDescriptionField.text
    }
    
    
    @IBAction func updateComplete(_ sender: Any) {
        TaskObjectDic.taskDic[dateKey.key]![modifiedIndex.index].taskTitle = updatedTitle
        
        TaskObjectDic.taskDic[dateKey.key]![modifiedIndex.index].taskDescription = updatedDescription
        
        let uDefault = UserDefaults.standard
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: TaskObjectDic.taskDic)
        
        uDefault.set(encodedData, forKey: "eventDic")
        
        self.dismiss(animated: true, completion: nil)
    }
}

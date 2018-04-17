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
        
        self.tableView.register(DateDetsTableViewCell.self, forCellReuseIdentifier: "cell")
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

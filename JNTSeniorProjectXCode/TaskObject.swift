
//  Created by Thomas Zorn on 3/31/18.
//  Copyright © 2018 Tom, Jack, and Natalie. All rights reserved.
//

import Foundation
import CoreData
//Object to hold user events and schedule
class TaskObject: NSObject, NSCoding
{
    var taskDate:Date!
    var taskTitle:String!
    var taskDescription:String!
    var taskPriority:Int!
    
    init(taskDate: Date, taskTitle: String, taskDescription: String, taskPriority: Int)
    {
        self.taskDate = taskDate
        self.taskTitle = taskTitle
        self.taskDescription = taskDescription
        self.taskPriority = taskPriority
    
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(taskDate, forKey: "dateK")
        aCoder.encode(taskTitle, forKey: "titleK")
        aCoder.encode(taskDescription, forKey: "descK")
        aCoder.encode(taskPriority, forKey: "priorK")
    }
    
    
    required convenience init(coder aDecoder: NSCoder) {
        let taskDate = aDecoder.decodeObject(forKey: "dateK") as! Date
        let taskTitle = aDecoder.decodeObject(forKey: "titleK") as! String
        let taskDescription = aDecoder.decodeObject(forKey: "descK") as! String
        let taskPriority = aDecoder.decodeObject(forKey: "priorK") as! Int
        self.init(taskDate: taskDate, taskTitle: taskTitle, taskDescription: taskDescription, taskPriority: taskPriority)
    }
    

}






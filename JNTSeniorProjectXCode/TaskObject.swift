
//  Created by Thomas Zorn on 3/31/18.
//  Copyright © 2018 Tom, Jack, and Natalie. All rights reserved.
//

import Foundation
import CoreData
//Object to hold user events
class TaskObject: NSObject, NSCoding
{
    //variables to hold a users event info
    var taskDate:Date!
    var taskTitle:String!
    var taskDescription:String!
    var taskPriority:Int!
    var taskMadeDate:Date!
    
    //init the object
    init(taskDate: Date, taskTitle: String, taskDescription: String, taskPriority: Int, taskMadeDate: Date)
    {
        self.taskDate = taskDate
        self.taskTitle = taskTitle
        self.taskDescription = taskDescription
        self.taskPriority = taskPriority
        self.taskMadeDate = taskMadeDate
    
    }//end init
    
    //func to encode each variable with a unique key
    func encode(with aCoder: NSCoder) {
        aCoder.encode(taskDate, forKey: "dateK")
        aCoder.encode(taskTitle, forKey: "titleK")
        aCoder.encode(taskDescription, forKey: "descK")
        aCoder.encode(taskPriority, forKey: "priorK")
        aCoder.encode(taskMadeDate, forKey: "madeD")
    }//end func
    
    //func to decode each variable with a specified key
    required convenience init(coder aDecoder: NSCoder) {
        let taskDate = aDecoder.decodeObject(forKey: "dateK") as! Date
        let taskTitle = aDecoder.decodeObject(forKey: "titleK") as! String
        let taskDescription = aDecoder.decodeObject(forKey: "descK") as! String
        let taskPriority = aDecoder.decodeObject(forKey: "priorK") as! Int
        let taskMadeDate = aDecoder.decodeObject(forKey: "madeD") as! Date
        self.init(taskDate: taskDate, taskTitle: taskTitle, taskDescription: taskDescription, taskPriority: taskPriority, taskMadeDate: taskMadeDate)
    }//end func
}






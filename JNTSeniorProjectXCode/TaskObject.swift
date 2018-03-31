
//  Created by Thomas Zorn on 3/31/18.
//  Copyright © 2018 Tom, Jack, and Natalie. All rights reserved.
//

import Foundation
//Object to hold user events and schedule
class TaskObject
{
    var taskDate:Date!
    var taskTitle:String!
    var taskDescription:String!
    //var taskPriority:Int!
}

//Dictionary with a date as its key, and whatever events on that day will be stored
struct TaskObjectDic
{
    static var taskDic = [String:Array<TaskObject>]()
}


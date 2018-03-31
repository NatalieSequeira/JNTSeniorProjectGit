//
//  TaskObject.swift
//  JNTSeniorProjectXCode
//
//  Created by Thomas Zorn on 3/30/18.
//  Copyright © 2018 Tom, Jack, and Natalie. All rights reserved.
//

import Foundation

class TaskObject
{
    var taskDate:Date!
    var taskTitle:String!
    var taskDescription:String!
    //var taskPriority:Int!
}

struct TaskObjectDic
{
    static var taskDic = [String:Array<TaskObject>]()
}

//
//  SaveFetchTaskDictionary.swift
//  JNTSeniorProjectXCode
//
//  Created by Thomas Zorn on 4/2/18.
//  Copyright © 2018 Tom, Jack, and Natalie. All rights reserved.
//

import Foundation
import CoreData
import UIKit

/*
 If NSDictionary doesn't work with core data do this instead:
 Take the dictionary, and store all the keys in an array. Then store
 title, description, date, and priority into their own arrays. Store
 each array as persistant data. When fetching the data, create a TaskObject
 that will take in each attribute stored (title, description, etc.). Start by
 checking to see if a key already exists in the dictionary. If it does not, then
 place the TaskObject into the array for that key. If it does, append TaskObject into
 the array for that key. This is done already when creating the dictionary in AddEvent.
 */


class SaveFetchTaskDictionary
{
    /*var tDictionary = [String:Array<TaskObject>]()
    
     init(){
    }
    
    func saveload()
    {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        //Save keys
        let entity1 = NSEntityDescription.entity(forEntityName: "DictionaryKeys", in: context)
        let dictKey = NSManagedObject(entity: entity1!, insertInto: context)
        
        //Save values
        let entity2 = NSEntityDescription.entity(forEntityName: "DictionaryValues", in: context)
        let dictValue = NSManagedObject(entity: entity2!, insertInto: context)
    
        
        for(dictK,dictV) in TaskObjectDic.taskDic
        {
            dictKey.setValue(dictK, forKey: "dictKey")
            for(toValue) in dictV
            {
                dictValue.setValue(toValue.taskTitle, forKey: "title")
                dictValue.setValue(toValue.taskDescription, forKey: "desc")
                dictValue.setValue(toValue.taskDate, forKey: "date")
            }
            
        }
    }*/
    
}




//Dictionary with a date as its key, and whatever events on that day will be stored
struct TaskObjectDic
{
    static var taskDic = [String:Array<TaskObject>]()
}

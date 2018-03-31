//
//  TasksViewController.swift
//  
//
//  Created by Thomas Zorn on 3/28/18.
//

import UIKit
import EventKit
import CoreData

var calID = "null"

class TasksViewController: UIViewController{
    
    let eventStore = EKEventStore()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //CoreData init
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "CalendarID", in: context)
        let calenID = NSManagedObject(entity: entity!, insertInto: context)
        
        
        eventStore.requestAccess(to: EKEntityType.event) {
            (accessYes, accessNo) in
            
            if (accessYes) && (accessNo == nil){
        // Creation of apple calender to be used in this app.
        let calendars = self.eventStore.calendars(for: EKEntityType.event) as [EKCalendar]
        var exists = false
        for calendar in calendars {
            if calendar.title == "AppCalendar" {
                exists = true
                calID = calendar.calendarIdentifier
            }
        }
        
        if exists == false {
            let newCalendar = EKCalendar(for:EKEntityType.event, eventStore:self.eventStore)
            newCalendar.title="AppCalendar"
            //print(newCalendar.calendarIdentifier)
            calID = newCalendar.calendarIdentifier
            print("48 - Current calID" + calID)
            newCalendar.source = self.eventStore.defaultCalendarForNewEvents?.source
            do{
            try self.eventStore.saveCalendar(newCalendar, commit:true)
            }
            catch{ print("Help")
            }
        }
                
            
            }
            else{
                print("Did not have permission to use Calender")
            }
            
            
            print("64 - Current calID" + calID)
            calenID.setValue(calID, forKey: "appleCalendarID")
            
            do{
                try context.save()
                print("69 - Saved ID: " + calID)
            } catch {
                print("Failed Saving")
            }
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CalendarID")
            request.returnsObjectsAsFaults = false
            
            do {
                let result = try context.fetch(request)
                for data in result as! [NSManagedObject]{
                    calID = data.value(forKeyPath: "appleCalendarID") as! String
                    print("81 - Loaded: " + calID)
                }
            } catch {
                print("Failed")
                
            }
        }
            
        
    
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
 
    }
}

struct CalendarIDStruct
{
    static var calendarID = calID
}


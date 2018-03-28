//
//  TasksViewController.swift
//  
//
//  Created by Thomas Zorn on 3/28/18.
//

import UIKit
import EventKit


class TasksViewController: UIViewController{
    
   
    
    var calendarID:String = " "
    
    let eventStore = EKEventStore()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventStore.requestAccess(to: EKEntityType.event) {
            (accessYes, accessNo) in
            
            if (accessYes) && (accessNo == nil){
        // Creation of apple calender to be used in this app.
        let calendars = self.eventStore.calendars(for: EKEntityType.event) as [EKCalendar]
        var exists = false
        for calendar in calendars {
            if calendar.title == "evenCal" {
                exists = true
            }
        }
        
        if exists == false {
            let newCalendar = EKCalendar(for:EKEntityType.event, eventStore:self.eventStore)
            newCalendar.title="evenCal"
            print(newCalendar.calendarIdentifier)
            propertyKey.calID = newCalendar.calendarIdentifier
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
            
            

        // Do any additional setup after loading the view.
    }
        
        
        }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
 
    }
    
}

struct propertyKey
{
    static var calID = ""
}


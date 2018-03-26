//
//  AddEventViewController.swift
//  JNTSeniorProjectXCode
//
//  Created by Tom, Jack, and Natalie on 2/25/18.
//  Copyright © 2018 Tom, Jack, and Natalie. All rights reserved.
//

import UIKit
import EventKit

class AddEventViewController: UIViewController {
    
    
    // DEFAULT FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        myDatePicker.isHidden = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // END DEFAULT FUNCTIONS
    
    
    // Outlets from AddEvent Storyboard
    
    // Bad Name, this button adds the task to the Calendar. MAY CHANGE THESE BAD NAMES LATER
    @IBOutlet weak var testButton: UIButton!
    
    // The date picker that pops up. Visibility set to False by default.
    @IBOutlet weak var myDatePicker: UIDatePicker!
    
    // Bad Name, this label shows the date after it's been picked using myDatePicker.
    @IBOutlet weak var testLabel: UILabel!
    
    // TextField for users to put a title for event
    @IBOutlet weak var titleTextField: UITextField!
    
    // TextField for users to put a description for the event.
    @IBOutlet weak var descriptionTextField: UITextField!
    
    // Button that will make the date picker appear.
    @IBOutlet weak var selectDateButton: UIButton!
    
    
    // Other needed variables
    
    var userTitle: String? = ""
    
    var userDescription: String?
    
    
    
    
    

    
    
    
    @IBAction func bringUpDatePicker(_ sender: Any) {
        
        myDatePicker.isHidden = false
    }
    
    
    @IBAction func titleTextFieldChanged(_ sender: Any) {
        userTitle = titleTextField.text!
    }
    
    
    @IBAction func descriptionTextFieldChanged(_ sender: Any) {
        userDescription = descriptionTextField.text!
    }
    
    
    
    
    
    
    
    
    //start of func AddEvent
    func addEvent(title: String!, startDate: Date, endDate: Date, description: String!) {
        
        let eventStore = EKEventStore()
        
        eventStore.requestAccess(to: EKEntityType.event) {
            (accessYes, accessNo) in
            
            if (accessYes) && (accessNo == nil){
                
                let actualEvent: EKEvent = EKEvent(eventStore: eventStore)
                
                actualEvent.title = title!
                actualEvent.startDate = startDate
                actualEvent.endDate = endDate
                actualEvent.notes = description!
                actualEvent.calendar = eventStore.defaultCalendarForNewEvents
                
                do{
                    try eventStore.save(actualEvent, span: .thisEvent)
                }
                catch{
                    print("Error has occurred")
                    
                }
                print("Success")
            }
            else{
                print("Did not have permission to use Calendar")
            }
        }
    }
    //end of func
    
    
    
    
    
    
    
    
    
    
    
    // Add the Event to the Calendar
    @IBAction func buttonPressed(_ sender: Any) {
        
        let myDateFormatter = DateFormatter()
        let myLocale = NSLocale.autoupdatingCurrent;
        
        myDateFormatter.locale = myLocale
        
        myDateFormatter.dateFormat = "MM dd, YYYY"
        
        
        
        if(userTitle == "" || userTitle == nil){
            // Standard alert from Apple's website
            let missingTitleAlert = UIAlertController(title: "No Title", message: "Please add a title", preferredStyle: .alert)
            missingTitleAlert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            self.present(missingTitleAlert, animated: true, completion: nil)
        }
        else{
            addEvent(title: userTitle!, startDate: myDatePicker.date, endDate: myDatePicker.date, description: userDescription!)
            
            self.dismiss(animated: true, completion: nil)
            
        }
        
    }
    
    
    
    
    
    
}


//
//  SecondViewController.swift
//  JNTSeniorProjectXCode
//
//  Created by Kenneth on 2/25/18.
//  Copyright © 2018 Tom, Jack, and Natalie. All rights reserved.
//

import UIKit
import EventKit
import JTAppleCalendar

class SecondViewController: UIViewController {

    let formatter = DateFormatter()
    
    //declare variables to be used
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var month: UILabel!
    @IBOutlet weak var year: UILabel!
    
    //set todays date
    let todaysDate = Date()
    
    //func to check if a popover was dismissed, reload the calendar view
    func popoverPresentationControllerDidDismissPopover(popoverPresentationController: UIPopoverPresentationController){
        calendarView.reloadData()
    }//end func

    override func viewDidLoad() {
        super.viewDidLoad()
        calendarView.scrollToDate( Date() )
        setupCalendarView()
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        calendarView.reloadData()
        //Test
    }
    
    //func to set up the calendar
    func setUpViewsOfCalendar(from visibleDates: DateSegmentInfo)
    {
        let date = visibleDates.monthDates.first!.date
        
        self.formatter.dateFormat = "yyyy"
        self.year.text = formatter.string(from: date)
        
        self.formatter.dateFormat = "MMM"
        self.month.text = formatter.string(from: date)
    }//end func
    

    //func to set up which dates are currently visible
    func setupCalendarView(){
        // calendarView.minimumLineSpacing = 0
        // calendarView.minimumInteritemSpacing = 0
        
        calendarView.visibleDates { visibleDates in
            self.setUpViewsOfCalendar(from: visibleDates)
        }
    }//end func
    
    
    //func to configure a date cell
    func configureCell(cell:JTAppleCell?, cellState: CellState)
    {
        guard let myCustomCell = cell as? CustomCell else {return}
        formatter.dateFormat = "yyyy MM dd"
        
        handleCelltextColor(cell: myCustomCell, cellState: cellState)
        handleCellEvents(cell: myCustomCell, cellState: cellState)
        handleCellSelection(cell: myCustomCell, cellState: cellState)
    }//end func
    
    //func to color a date cell
    func handleCelltextColor(cell: CustomCell, cellState: CellState)
    {
        //guard let validCell = view as? CustomCell else {return}
        
        formatter.dateFormat = "yyyy MM dd"
        
        let todaysDateString = formatter.string(from: todaysDate)
        let monthDateString = formatter.string(from: cellState.date)
        
        //if the date cell isnt part of the current month, shade it gray
        cell.dateLabel.textColor = cellState.dateBelongsTo == .thisMonth ? UIColor.black : UIColor.gray
        
        //if it's today date make the date label red
        if todaysDateString == monthDateString{
            cell.dateLabel.textColor = UIColor.red
        }//end if
        
    }//end function
    
    //func to determine if there is an event on this day
    func handleCellEvents(cell: CustomCell, cellState: CellState)
    {
        formatter.dateFormat = "yyyy MM dd"
        let eventDate = cellState.date
        
        //check to see if there is event on that date, and if the array at that date is not empty
        if (TaskObjectDic.taskDic[formatter.string(from: eventDate)] != nil && TaskObjectDic.taskDic[formatter.string(from: eventDate)]?.count != 0)
        {
            cell.eventDotView.isHidden = false
        }else{
            cell.eventDotView.isHidden = true
        }//end if
    }//end func
    

    func handleCellSelection(cell: CustomCell, cellState: CellState)
    {
        //cell.selectedView.isHidden = cellState.isSelected ? false : true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension SecondViewController: JTAppleCalendarViewDataSource{
    
    //func to set up the calendar with a specified cell
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        
        let myCustomCell = cell as! CustomCell
        
        sharedFunctionToConfigureCell(myCustomCell: myCustomCell, cellState: cellState, date: date)
    }//end func
    
    
    //func to configure the calendar for a specific date range
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters{
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = formatter.date(from: "2018 01 01")!
        let endDate = formatter.date(from: "2030 02 01")!
        
        
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate)
        return parameters
    }//end func
    
    //func to set each cell's text to the respective day
    func sharedFunctionToConfigureCell(myCustomCell: CustomCell, cellState: CellState, date: Date){
        myCustomCell.dateLabel.text = cellState.text
    }
    
}

extension SecondViewController: JTAppleCalendarViewDelegate {
    
    //func to link the calendar cell to a created cell
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        
        let myCustomCell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCell
        
        configureCell(cell: myCustomCell, cellState: cellState)
        
        sharedFunctionToConfigureCell(myCustomCell: myCustomCell, cellState: cellState, date: date)
        return myCustomCell
    }//end func
    
    //func to display the proper days of a specified month when scrolling
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setUpViewsOfCalendar(from: visibleDates)
    }//end func
    
    //func to configure a cell once a cell has been deselected
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(cell: cell, cellState: cellState)
    }//end func
    
    //func to check if a selected date has an event on it
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState){
        
        formatter.dateFormat = "yyyy MM dd"
        guard let validCell = cell as? CustomCell else {return}
        
        configureCell(cell: cell, cellState: cellState)
        
        validCell.selectedView.isHidden = true
        print(formatter.string(from: date))
        //set the dateKey stuct to the selected date
        dateKey.key = formatter.string(from: date)
        
        //if there is a event on this day, popover to a tableview display what events are occuring on this day
        if (TaskObjectDic.taskDic[formatter.string(from: date)] != nil && TaskObjectDic.taskDic[formatter.string(from: date)]?.count != 0)
        {
            let popoverContent = self.storyboard?.instantiateViewController(withIdentifier: "Date Dets View Controller") as UIViewController?
            let navigation = UINavigationController(rootViewController: popoverContent!)
            navigation.modalPresentationStyle = UIModalPresentationStyle.popover
            let popover = navigation.popoverPresentationController
            popover?.delegate = self as? UIPopoverPresentationControllerDelegate
            popover?.sourceView = self.view
            
            self.present(navigation, animated: true, completion: nil)
            
        }//end if
        
    }//end func
}

//struct to store what the current dateKey is
struct dateKey
{
    static var key:String!
}//end struct


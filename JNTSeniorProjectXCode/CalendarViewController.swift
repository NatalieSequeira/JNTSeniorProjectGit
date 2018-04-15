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
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var month: UILabel!
    @IBOutlet weak var year: UILabel!
    
    let todaysDate = Date()
    
    

    // Extra code added to the default viewDidLoad func
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarView.scrollToDate( Date() )
        setupCalendarView()
        }
    
    func setUpViewsOfCalendar(from visibleDates: DateSegmentInfo)
    {
        let date = visibleDates.monthDates.first!.date
        
        self.formatter.dateFormat = "yyyy"
        self.year.text = formatter.string(from: date)
        
        self.formatter.dateFormat = "MMMM"
        self.month.text = formatter.string(from: date)
    }
    

    func setupCalendarView(){
        // calendarView.minimumLineSpacing = 0
        // calendarView.minimumInteritemSpacing = 0
        
        calendarView.visibleDates { visibleDates in
            self.setUpViewsOfCalendar(from: visibleDates)
        }
        
    }
    
    func configureCell(cell:JTAppleCell?, cellState: CellState)
    {
        guard let myCustomCell = cell as? CustomCell else {return}
        formatter.dateFormat = "yyyy MM dd"
        
        handleCelltextColor(cell: myCustomCell, cellState: cellState)
        handleCellEvents(cell: myCustomCell, cellState: cellState)
        handleCellSelection(cell: myCustomCell, cellState: cellState)
    }
    
    func handleCelltextColor(cell: CustomCell, cellState: CellState)
    {
        //guard let validCell = view as? CustomCell else {return}
        
        formatter.dateFormat = "yyyy MM dd"
        
        let todaysDateString = formatter.string(from: todaysDate)
        let monthDateString = formatter.string(from: cellState.date)
        
        cell.dateLabel.textColor = cellState.dateBelongsTo == .thisMonth ? UIColor.black : UIColor.gray
        
        if todaysDateString == monthDateString{
            cell.dateLabel.textColor = UIColor.red
        }
    }
    
    func handleCellEvents(cell: CustomCell, cellState: CellState)
    {
        formatter.dateFormat = "yyyy MM dd"
        let eventDate = cellState.date
        
        if TaskObjectDic.taskDic[formatter.string(from: eventDate)] != nil
        {
            cell.eventDotView.isHidden = false
        }else{
            cell.eventDotView.isHidden = true
        }
    }
    
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
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        
        let myCustomCell = cell as! CustomCell
        
        sharedFunctionToConfigureCell(myCustomCell: myCustomCell, cellState: cellState, date: date)
    }
    
    
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters{
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = formatter.date(from: "2018 01 01")!
        let endDate = formatter.date(from: "2030 02 01")!
        
        
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate)
        return parameters
    }
    func sharedFunctionToConfigureCell(myCustomCell: CustomCell, cellState: CellState, date: Date){
        myCustomCell.dateLabel.text = cellState.text
    }
    
}

extension SecondViewController: JTAppleCalendarViewDelegate {
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        
        let myCustomCell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCell
        
        configureCell(cell: myCustomCell, cellState: cellState)
        
        sharedFunctionToConfigureCell(myCustomCell: myCustomCell, cellState: cellState, date: date)
        return myCustomCell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(cell: cell, cellState: cellState)
    }
    
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState){
        
        formatter.dateFormat = "yyyy MM dd"
        guard let validCell = cell as? CustomCell else {return}
        
        configureCell(cell: cell, cellState: cellState)
        
        validCell.selectedView.isHidden = true
        print(formatter.string(from: date))
        dateKey.key = formatter.string(from: date)
        
        if TaskObjectDic.taskDic[formatter.string(from: date)] != nil
        {
            let popoverContent = self.storyboard?.instantiateViewController(withIdentifier: "Date Dets View Controller") as UIViewController?
            let navigation = UINavigationController(rootViewController: popoverContent!)
            navigation.modalPresentationStyle = UIModalPresentationStyle.popover
            let popover = navigation.popoverPresentationController
            popover?.delegate = self as? UIPopoverPresentationControllerDelegate
            popover?.sourceView = self.view
            
            self.present(navigation, animated: true, completion: nil)
            
        }
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo, cellState: CellState, myCustomCell: CustomCell) {
        setUpViewsOfCalendar(from: visibleDates)
    }

}

struct dateKey
{
    static var key:String!
}


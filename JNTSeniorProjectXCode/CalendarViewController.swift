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

    
    // Extra code added to the default viewDidLoad func
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCalendarView()
        calendarView.scrollToDate( Date() )
    }
    
    func handleCelltextColor(view: JTAppleCell?, cellState: CellState)
    {
        guard let validCell = view as? CustomCell else {return}
        
        if cellState.dateBelongsTo == .thisMonth
        {
            validCell.dateLabel.textColor = UIColor.black
        } else {
            validCell.dateLabel.textColor = UIColor.gray
        }
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
        
        let startDate = formatter.date(from: "2018 01 01")
        let endDate = formatter.date(from: "2030 02 01")!
        
        
        let parameters = ConfigurationParameters(startDate: startDate!, endDate: endDate)
        return parameters
    }
    func sharedFunctionToConfigureCell(myCustomCell: CustomCell, cellState: CellState, date: Date){
        myCustomCell.dateLabel.text = cellState.text
        
        
    }
    
}

extension SecondViewController: JTAppleCalendarViewDelegate {
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        

        let myCustomCell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCell
        
        handleCelltextColor(view: myCustomCell, cellState: cellState)
        //myCustomCell.dateLabel.text = cellState.text
        sharedFunctionToConfigureCell(myCustomCell: myCustomCell, cellState: cellState, date: date)
        return myCustomCell
    }
    
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState){
        guard let validCell = cell as? CustomCell else {return}
        
        
        validCell.selectedView.isHidden = true
        print(formatter.string(from: date))
        dateKey.key = formatter.string(from: date)
        
        if TaskObjectDic.taskDic[formatter.string(from: date)] != nil
        {
            let popoverContent = self.storyboard?.instantiateViewController(withIdentifier: "Date Dets View Controller") as UIViewController!
            let navigation = UINavigationController(rootViewController: popoverContent!)
            navigation.modalPresentationStyle = UIModalPresentationStyle.popover
            let popover = navigation.popoverPresentationController
            popover?.delegate = self as? UIPopoverPresentationControllerDelegate
            popover?.sourceView = self.view
            
            self.present(navigation, animated: true, completion: nil)
            
        }
        
    }
    
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setUpViewsOfCalendar(from: visibleDates)
    }
    
    
    
}

struct dateKey
{
    static var key:String!
}


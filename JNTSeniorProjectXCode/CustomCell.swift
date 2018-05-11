//
//  CustomCell.swift
//  
//
//  Created by Natalie on 3/21/18.
//

import UIKit
import JTAppleCalendar

class CustomCell: JTAppleCell {
    
    //configure the cell with a label, view, and dot for events
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var selectedView: UIView!
    @IBOutlet weak var eventDotView: UILabel!

}

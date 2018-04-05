//
//  DateDetsTableViewCell.swift
//  
//
//  Created by Thomas Zorn on 4/4/18.
//

import UIKit

class DateDetsTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var TaskNameLabel: UILabel!
    
    @IBOutlet weak var TaskInfoButton: UIButton!

}

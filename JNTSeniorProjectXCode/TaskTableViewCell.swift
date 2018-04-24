//
//  TaskTableViewCell.swift
//  JNTSeniorProjectXCode
//
//  Created by Thomas Zorn on 4/23/18.
//  Copyright © 2018 Tom, Jack, and Natalie. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    @IBOutlet weak var taskTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

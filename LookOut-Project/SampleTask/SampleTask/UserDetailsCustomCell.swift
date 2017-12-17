//
//  UserDetailsCustomCell.swift
//  SampleTask
//
//  Created by dinesh danda on 1/17/17.
//  Copyright © 2017 dinesh danda. All rights reserved.
//

import UIKit

class UserDetailsCustomCell: UITableViewCell {
    
    @IBOutlet weak var mailImage: UIImageView!
    
    @IBOutlet weak var emailIdLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    
}

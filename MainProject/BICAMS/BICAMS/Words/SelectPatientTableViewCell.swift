//
//  SelectPatientTableViewCell.swift
//  SiriDemo
//
//  Created by Balázs Bojrán on 2017. 04. 19..
//  Copyright © 2017. Balázs Bojrán. All rights reserved.
//

import UIKit

class SelectPatientTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var tajLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

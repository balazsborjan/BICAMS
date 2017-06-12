//
//  PatientInfoTableViewCell.swift
//  Telemedicina
//
//  Created by Balázs Bojrán on 2017. 05. 17..
//  Copyright © 2017. SZTE. All rights reserved.
//

import UIKit

class PatientInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var detailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

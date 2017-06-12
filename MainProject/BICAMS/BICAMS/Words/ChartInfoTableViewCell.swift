//
//  ChartInfoTableViewCell.swift
//  Telemedicina
//
//  Created by Balázs Bojrán on 2017. 05. 20..
//  Copyright © 2017. SZTE. All rights reserved.
//

import UIKit

class ChartInfoTableViewCell: UITableViewCell {

    weak var titleLabel: UILabel?
    
    weak var detailLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        titleLabel = UILabel(frame: CGRect(
            x: 0,
            y: 0,
            width: self.frame.width / 2,
            height: self.frame.height)
        )
        
        detailLabel = UILabel(frame: CGRect(
            x: self.frame.width / 2,
            y: 0,
            width: self.frame.width / 2,
            height: self.frame.height)
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

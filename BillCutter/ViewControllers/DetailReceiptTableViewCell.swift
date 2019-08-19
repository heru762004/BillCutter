//
//  DetailReceiptTableViewCell.swift
//  BillCutter
//
//  Created by Heru Prasetia on 19/8/19.
//  Copyright © 2019 Heru Prasetia. All rights reserved.
//

import UIKit

class DetailReceiptTableViewCell: UITableViewCell {
    
    @IBOutlet weak var itemName: UILabel!
    
    @IBOutlet weak var buttonPrice: UIButton!
    
    @IBOutlet weak var buttonDelete: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

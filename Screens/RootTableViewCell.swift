//
//  RootTableViewCell.swift
//  Screens
//
//  Created by Сергей Васильков on 27.09.2021.
//

import UIKit

class RootTableViewCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

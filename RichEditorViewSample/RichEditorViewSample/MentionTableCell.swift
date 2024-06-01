//
//  MentionTableCell.swift
//  RichEditorViewSample
//
//  Created by Ayyarappan K on 01/06/24.
//  Copyright © 2024 Caesar Wirth. All rights reserved.
//

import UIKit

class MentionTableCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(data: Users) {
        nameLabel.text = data.name
    }

}

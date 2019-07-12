//
//  MessageCell.swift
//  messagelist
//
//  Created by Nicholas Galasso on 7/9/19.
//  Copyright © 2019 Rockshassa. All rights reserved.
//

import UIKit

class MessageCell : UITableViewCell {
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func updateConstraints() {
        super.updateConstraints()
        avatar.layer.cornerRadius = avatar.frame.size.width/2
    }
    
    override func prepareForReuse() {
        avatar.image = nil
        contentLabel.text = nil
        super.prepareForReuse()
    }
}

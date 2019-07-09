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
    
    override func prepareForReuse() {
        avatar.image = nil
        contentLabel.text = nil
        super.prepareForReuse()
    }
}

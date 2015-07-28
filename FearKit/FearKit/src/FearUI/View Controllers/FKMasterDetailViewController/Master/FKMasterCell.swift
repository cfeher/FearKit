//
//  FKMasterCell.swift
//  FearKit
//
//  Created by Chris Feher on 2015-07-27.
//  Copyright (c) 2015 Chris Feher. All rights reserved.
//

import UIKit

public class FKMasterCell: UITableViewCell {

	@IBOutlet weak var majorLabel: UILabel!
	@IBOutlet weak var leftImageView: UIImageView!

    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override public func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//
//  MemeGalleryTableViewCell.swift
//  TrendyMemes
//
//  Created by Pritam Hinger on 17/07/16.
//  Copyright © 2016 AppDevelapp. All rights reserved.
//

import UIKit

class MemeGalleryTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var topTitle: UILabel!
    @IBOutlet weak var bottomTitle: UILabel!
    @IBOutlet weak var createdDateTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

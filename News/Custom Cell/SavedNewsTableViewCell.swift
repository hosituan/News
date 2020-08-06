//
//  SavedNewsTableViewCell.swift
//  News
//
//  Created by Hồ Sĩ Tuấn on 8/6/20.
//  Copyright © 2020 Hồ Sĩ Tuấn. All rights reserved.
//

import UIKit

class SavedNewsTableViewCell: UITableViewCell {

    static let identifier = "cellID"
    @IBOutlet var linkLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(title: String, description: String, cellImageUrl: String, link: String){
        
        titleLabel.text = title
        descriptionLabel.text = description
        linkLabel.text = link
        if let url = URL(string: cellImageUrl) {
        cellImage.sd_setImage(with: url, completed: nil)
        }
    }

}

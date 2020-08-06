//
//  ConerRadiusImage.swift
//  News
//
//  Created by Hồ Sĩ Tuấn on 8/6/20.
//  Copyright © 2020 Hồ Sĩ Tuấn. All rights reserved.
//

import UIKit

class ConerRadiusImage: UIImageView {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 10
        self.isUserInteractionEnabled = true
    }

}

//
//  NewsDetailViewController.swift
//  News
//
//  Created by Hồ Sĩ Tuấn on 8/3/20.
//  Copyright © 2020 Hồ Sĩ Tuấn. All rights reserved.
//

import UIKit
import SDWebImage

class NewsDetailViewController: UIViewController {

    var time, source, content, newsTitle: String?
    var imageMainURL, imageSourceURL: URL?
    
    
    @IBOutlet var backButton: UIButton!
    @IBOutlet var imageMain: UIImageView!
    @IBOutlet var imageSouce: UIImageView!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var sourceLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var contentView: UIView!
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var imageView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    func updateUI() {
        imageMain.layer.cornerRadius = 20
        backButton.backgroundColor = UIColor(rgb: 0xA0A5B5).withAlphaComponent(0.2)
        backButton.layer.cornerRadius = 5
        self.imageMain.layer.maskedCorners = [ .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        if let title = newsTitle {
            self.titleLabel.text = title
        }
        if let time = time {
            self.timeLabel.text = time
        }
        if let source = source {
            self.sourceLabel.text = source
        }
        if let content = content {
            self.contentLabel.text = content
        }
        if let imageURL = imageMainURL {
            self.imageMain.sd_setImage(with: imageURL, completed: nil)
        }
    }

    @IBAction func tapBackButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tabShareButton(_ sender: UIButton) {
    }
    
    @IBAction func tapSaveButton(_ sender: UIButton) {
    }
}

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
    
    var time, source, content, newsTitle, link: String?
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
    @IBOutlet var linkLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    func updateUI() {
        imageMain.layer.cornerRadius = 20
        linkLabel.isUserInteractionEnabled = true
        let tapLinkLabel = UITapGestureRecognizer(target: self, action: #selector(NewsDetailViewController.tapLinkLabel(sender:)))
        linkLabel.isUserInteractionEnabled = true
        linkLabel.addGestureRecognizer(tapLinkLabel)
        
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
        if let imageSourceURL = imageSourceURL {
            self.imageSouce.sd_setImage(with: imageSourceURL, completed: nil)
        }
        if let link = link {
            self.linkLabel.text = link
        }
    }
    @IBAction func tapLinkLabel(sender: UITapGestureRecognizer) {
        if let link = link {
            if let url = URL(string: link) {
                UIApplication.shared.open(url)
            }
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

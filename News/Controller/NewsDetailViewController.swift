//
//  NewsDetailViewController.swift
//  News
//
//  Created by Hồ Sĩ Tuấn on 8/3/20.
//  Copyright © 2020 Hồ Sĩ Tuấn. All rights reserved.
//

import UIKit
import SDWebImage
import SwiftMessages

class NewsDetailViewController: UIViewController {
    
    var time, newsDescription, source, content, newsTitle, link: String?
    var imageMainURL, imageSourceURL: URL?
    @IBOutlet var backButton: UIButton!
    @IBOutlet var imageMain: UIImageView!
    @IBOutlet var imageSource: UIImageView!
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
        imageSource.layer.cornerRadius = 0.5 * self.imageSource.bounds.size.width
        
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
        newsManager.getSourceImageURL(currentPage) { result in
            self.imageSource.sd_setImage(with: result, completed: nil)
        }
        if let imageSourceURL = imageSourceURL {
            self.imageSource.sd_setImage(with: imageSourceURL, completed: nil)
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
        //show alert
        let warning = MessageView.viewFromNib(layout: .cardView)
        warning.configureTheme(.success)
        warning.configureDropShadow()
        
        warning.configureContent(title: "Success", body: "Saved")
        warning.button?.isHidden = true
        var warningConfig = SwiftMessages.defaultConfig
        warningConfig.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
        SwiftMessages.show(config: warningConfig, view: warning)
        
        //save value
        let title:String = newsTitle ?? "No Title"
        let description:String = newsDescription ?? "No Description"
        let imageLink:String = imageMainURL?.absoluteString ?? ""
        let newsLink:String = link ?? ""
        saveNewsCoreDataManager.createData(title: title, description: description, imageLink: imageLink, link: newsLink)
    }
}

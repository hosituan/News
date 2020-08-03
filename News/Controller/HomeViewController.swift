//
//  SwipeViewController.swift
//  News
//
//  Created by Hồ Sĩ Tuấn on 8/1/20.
//  Copyright © 2020 Hồ Sĩ Tuấn. All rights reserved.
//

import UIKit
import UPCarouselFlowLayout
import ProgressHUD


class HomeViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var sourceImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var sourceLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    var newsManager = NewsManager()
    var sourceManager = SourceManager()
    var currentPage = 0
    var user = User(name: "Ho Si Tuan", categoryID: 1)
    
    var orientation: UIDeviceOrientation {
        return UIDevice.current.orientation
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsManager.fetchURL(url: "bitcoin") {
            self.sourceManager.fetchURL(url: "") {
                DispatchQueue.main.async {
                    self.collectionView.delegate = self
                    self.collectionView.dataSource = self
                }
            }
        }
        
        setUpUI()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showNewsDetail" {
            let vc = segue.destination as! NewsDetailViewController
            vc.newsTitle = newsManager.getTitle(currentPage)
            vc.content = newsManager.getContent(currentPage)
            vc.time = newsManager.getTime(currentPage)
            vc.source = newsManager.getSource(currentPage)
            vc.imageMainURL = newsManager.getURLImage(currentPage)
            vc.imageSourceURL = newsManager.getSourceImageURL(currentPage)
            vc.link = newsManager.getLink(currentPage)
        }
    }
    
    func setUpUI() {
        sourceImageView.layer.cornerRadius = 0.5 * self.sourceImageView.bounds.size.width
        sourceLabel.isUserInteractionEnabled = true
        let tapSourceLabel = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.tapSourceLabel(sender:)))
        sourceLabel.isUserInteractionEnabled = true
        sourceLabel.addGestureRecognizer(tapSourceLabel)
    }
    @IBAction func tapSourceLabel(sender: UITapGestureRecognizer) {
        print(currentPage)
        if let url = newsManager.getSourceURL(currentPage) {
            UIApplication.shared.open(url)
        }
    }
}


extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newsManager.getTotalResult()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier, for: indexPath) as! CustomCollectionViewCell
        currentPage = indexPath.row
        if let url = newsManager.getURLImage(indexPath.row) {
            cell.imageView.sd_setImage(with: url, completed: nil)
        }
        self.titleLabel.text = newsManager.getTitle(indexPath.row)
        self.descriptionLabel.text = newsManager.getDescription(indexPath.row)
        self.sourceLabel.text = newsManager.getSource(indexPath.row)
        self.timeLabel.text = newsManager.getTime(indexPath.row)
        if let url = newsManager.getSourceImageURL(indexPath.row) {
            self.sourceImageView.sd_setImage(with: url, completed: nil)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentPage = indexPath.row
        self.performSegue(withIdentifier: "showNewsDetail", sender: nil)
    }
}




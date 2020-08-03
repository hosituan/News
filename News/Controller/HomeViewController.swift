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
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var sourceLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    var imageArr: [UIImage] = []
    var newsManager = NewsManager()
    var currentPage = 0
    var user = User(name: "Ho Si Tuan", categoryID: 1)
    
    var orientation: UIDeviceOrientation {
        return UIDevice.current.orientation
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsManager.fetchUrl(url: "bitcoin") {
            DispatchQueue.main.async {
                self.collectionView.delegate = self
                self.collectionView.dataSource = self
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showNewsDetail" {
            let vc = segue.destination as! NewsDetailViewController
            vc.newsTitle = newsManager.getTitle(currentPage)
            vc.content = newsManager.getContent(currentPage)
            vc.time = newsManager.getTime(currentPage)
            vc.source = newsManager.getSource(currentPage)
            vc.imageMainURL = newsManager.getURLImage(currentPage)
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
        if let url = newsManager.getURLImage(indexPath.row) {
            cell.imageView.sd_setImage(with: url, completed: nil)
        }
        self.titleLabel.text = newsManager.getTitle(indexPath.row)
        self.descriptionLabel.text = newsManager.getDescription(indexPath.row)
        self.sourceLabel.text = newsManager.getSource(indexPath.row)
        self.timeLabel.text = newsManager.getTime(indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentPage = indexPath.row
        self.performSegue(withIdentifier: "showNewsDetail", sender: nil)
    }
}




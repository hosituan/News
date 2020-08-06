//
//  SwipeViewController.swift
//  News
//
//  Created by Hồ Sĩ Tuấn on 8/1/20.
//  Copyright © 2020 Hồ Sĩ Tuấn. All rights reserved.
//

import UIKit
import UPCarouselFlowLayout
import MBProgressHUD
import SkyFloatingLabelTextField

var needToReload = false
var currentPage = 0
var newsManager = NewsManager()

class HomeViewController: UIViewController {
    
    
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var sourceImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var sourceLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    @IBOutlet var searchTextField: SkyFloatingLabelTextField!
    
    
    
    var orientation: UIDeviceOrientation {
        return UIDevice.current.orientation
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadNews()
        setUpUI()
    }
    
    //load news if category change
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if needToReload {
            needToReload = false
            loadNews()
            categoryLabel.text = newsManager.getShowingCategory()
        }
    }
    @IBAction func tapSearchButton(_ sender: UIButton) {
        
        searchTextField.endEditing(true)
        
        if categoryLabel.isHidden {
            hideObject(searchTextField)
            showObject(categoryLabel)
            
        }
        else {
            hideObject(categoryLabel)
            showObject(searchTextField)
        }
        
        
        
        
    }
    
    @IBAction func tapSettingButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "openSetting", sender: nil)
    }
    
    @IBAction func tapSourceLabel(sender: UITapGestureRecognizer) {
        UIApplication.shared.open(newsManager.getSourceURL(currentPage))
    }
    func loadNews() {
        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading"
        searchTextField.delegate = self
        newsManager.fetchURL() {
            
            DispatchQueue.main.async {
                self.collectionView.delegate = self
                self.collectionView.dataSource = self
                
                self.collectionView!.reloadData()
                self.collectionView!.setNeedsDisplay()
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        }
    }
    
    func loadCategoryNews(_ categorySelected: String) {
        favoriteCategory = [categorySelected]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showNewsDetail" {
            let vc = segue.destination as! NewsDetailViewController
            vc.newsTitle = newsManager.getTitle(currentPage)
            vc.content = newsManager.getContent(currentPage)
            vc.time = newsManager.getTime(currentPage)
            vc.source = newsManager.getSource(currentPage)
            vc.imageMainURL = newsManager.getURLImage(currentPage)
            vc.newsDescription = newsManager.getDescription(currentPage)
            vc.imageSourceURL = newsManager.getTempSourceImageURL(currentPage)
            newsManager.getSourceImageURL(currentPage) {
                result in
                vc.imageSourceURL = result
            }
            vc.link = newsManager.getLink(currentPage)
        }
        if segue.identifier == "openSetting" {
            
        }
    }
    
    func setUpUI() {
        sourceImageView.layer.cornerRadius = 0.5 * self.sourceImageView.bounds.size.width
        sourceLabel.isUserInteractionEnabled = true
        let tapSourceLabel = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.tapSourceLabel(sender:)))
        sourceLabel.isUserInteractionEnabled = true
        sourceLabel.addGestureRecognizer(tapSourceLabel)
        categoryLabel.text = newsManager.getShowingCategory()
        searchTextField.textAlignment = .center
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
        cell.imageView.sd_setImage(with: newsManager.getURLImage(indexPath.row), completed: nil)
        self.titleLabel.text = newsManager.getTitle(indexPath.row)
        self.descriptionLabel.text = newsManager.getDescription(indexPath.row)
        self.sourceLabel.text = newsManager.getSource(indexPath.row)
        self.timeLabel.text = newsManager.getTime(indexPath.row)
        self.sourceImageView.sd_setImage(with: newsManager.getTempSourceImageURL(indexPath.row), completed: nil)
        newsManager.getSourceImageURL(indexPath.row) {
            url in
            if url != newsManager.getTempSourceImageURL(indexPath.row) {
                self.sourceImageView.sd_setImage(with: url, completed: nil)
            }
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentPage = indexPath.row
        self.performSegue(withIdentifier: "showNewsDetail", sender: nil)
    }
}


extension HomeViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        print("end")
        if searchTextField.text != "" {
            categoryLabel.text = searchTextField.text
            keyWord = searchTextField.text!
            
            let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
            loadingNotification.mode = MBProgressHUDMode.indeterminate
            loadingNotification.label.text = "Loading"
            
            newsManager.fetchURL {
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
            }
        }
        showObject(categoryLabel)
        hideObject(searchTextField)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func showObject(_ object: UIView) {
        UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            object.alpha = 1
        }, completion: { finished in
            object.isHidden = false
        })
    }
    
    func hideObject(_ object: UIView) {
        UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            object.alpha = 0
        }, completion: { finished in
            object.isHidden = true
        })
    }
    
}



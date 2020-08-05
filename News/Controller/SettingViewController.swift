//
//  SettingViewController.swift
//  News
//
//  Created by Hồ Sĩ Tuấn on 8/4/20.
//  Copyright © 2020 Hồ Sĩ Tuấn. All rights reserved.
//

import UIKit
import CoreData

class SettingViewController: UIViewController {
    //view in Category View
    @IBOutlet var allNewsView: UIView!
    @IBOutlet var myFeedView: UIView!
    @IBOutlet var savedView: UIView!

    
    //view in Favorite View
    @IBOutlet var scienceFavView: UIView!
    @IBOutlet var healthFavView: UIView!
    @IBOutlet var sportFavView: UIView!
    @IBOutlet var businessFavView: UIView!
    @IBOutlet var technologyFavView: UIView!
    @IBOutlet var entertaimentFavView: UIView!
    @IBOutlet var scrollView: UIScrollView!
    
    @IBAction func tapIsShowFavorite(_ sender: UISwitch) {
        needToReload = true
        coreDataManager.updateShowFavorite(sender.isOn)
    }
    @IBOutlet var isShow: UISwitch!
    @IBAction func tapBackButton(_ sender: BackButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapFavoriteButton(_ sender: UIButton) {
        needToReload = true
        isShow.isOn = true
        coreDataManager.updateShowFavorite(isShow.isOn)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapCategoryButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapAllNewsView(sender: UITapGestureRecognizer) {
        needToReload = true
        allNewsView.backgroundColor = #colorLiteral(red: 0.1254901961, green: 0.8039215686, blue: 0.5176470588, alpha: 1)
        category = allNewsView.accessibilityIdentifier!
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func tapMyFeedView(sender: UITapGestureRecognizer) {
        needToReload = true
        myFeedView.backgroundColor = #colorLiteral(red: 0.1254901961, green: 0.8039215686, blue: 0.5176470588, alpha: 1)
        category = myFeedView.accessibilityIdentifier!
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func tapSavedView(sender: UITapGestureRecognizer) {
        needToReload = true
        savedView.backgroundColor = #colorLiteral(red: 0.1254901961, green: 0.8039215686, blue: 0.5176470588, alpha: 1)
        category = savedView.accessibilityIdentifier!
        self.dismiss(animated: true, completion: nil)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.alwaysBounceHorizontal = true
        scrollView.delegate = self
        setUpUI()
    }
    func setUpUI() {
        isShow.isOn = coreDataManager.getShowFavorite()
        
        let tapAllView = UITapGestureRecognizer(target: self, action: #selector(self.tapAllNewsView(sender:)))
        allNewsView.addGestureRecognizer(tapAllView)
        
        let tapMyFeedView = UITapGestureRecognizer(target: self, action: #selector(self.tapMyFeedView(sender:)))
        myFeedView.addGestureRecognizer(tapMyFeedView)
        
        let tapSavedView = UITapGestureRecognizer(target: self, action: #selector(self.tapSavedView(sender:)))
        savedView.addGestureRecognizer(tapSavedView)
        
        category = ""
    }
}

//disable horizon scroll view
extension SettingViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
       if scrollView.contentOffset.y > 0 || scrollView.contentOffset.y < 0 {
          scrollView.contentOffset.y = 0
       }
    }
}

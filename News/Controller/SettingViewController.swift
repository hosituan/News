//
//  SettingViewController.swift
//  News
//
//  Created by Hồ Sĩ Tuấn on 8/4/20.
//  Copyright © 2020 Hồ Sĩ Tuấn. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    //view in Category View
    @IBOutlet var allNewsView: UIView!
    @IBOutlet var scienceView: UIView!
    @IBOutlet var businessView: UIView!
    @IBOutlet var sportView: UIView!
    @IBOutlet var entertaimentView: UIView!
    @IBOutlet var healthView: UIView!
    @IBOutlet var technologyView: UIView!
    
    //view in Favorite View
    @IBOutlet var scienceFavView: UIView!
    @IBOutlet var healthFavView: UIView!
    @IBOutlet var sportFavView: UIView!
    @IBOutlet var businessFavView: UIView!
    @IBOutlet var technologyFavView: UIView!
    @IBOutlet var entertaimentFavView: UIView!
    @IBOutlet var scrollView: UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.alwaysBounceHorizontal = true
        scrollView.delegate = self
        setUpUI()
        // Do any additional setup after loading the view.
    }
    func setUpUI() {

    }
}

extension SettingViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
       if scrollView.contentOffset.y > 0 || scrollView.contentOffset.y < 0 {
          scrollView.contentOffset.y = 0
       }
    }
}

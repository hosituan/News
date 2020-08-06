//
//  SavedNewsViewController.swift
//  News
//
//  Created by Hồ Sĩ Tuấn on 8/6/20.
//  Copyright © 2020 Hồ Sĩ Tuấn. All rights reserved.
//

import UIKit
import SwiftLinkPreview
import SkyFloatingLabelTextField
import RxSwift
import RxCocoa

var saveNewsCoreDataManager = SavedNewsCoreDataManager()
class SavedNewsViewController: UIViewController {
    
    var dispose = DisposeBag()
    
    @IBOutlet var searchText: SkyFloatingLabelTextField!
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        saveNewsCoreDataManager.loadData()
//        saveNewsCoreDataManager.bindingData()
        bindUI()
    }
    
    @IBAction func tapBackButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func changedText(_ sender: SkyFloatingLabelTextField) {
        print("abc")
    }
    
    func bindUI(){
        self.searchText.rx.text.throttle(1, scheduler: MainScheduler.instance).asObservable().bind(to: saveNewsCoreDataManager.searchInput).disposed(by: dispose)
        saveNewsCoreDataManager.searchResult.asObservable().bind(to: self.tableView.rx.items(cellIdentifier: "cellID", cellType: SavedNewsTableViewCell.self)) {
            (index, data, cell) in cell.configure(title: data.title ?? "No Title" , description: data.description ?? "No Description", cellImageUrl: data.urlToImage ?? "", link: data.url ?? "")
        }.disposed(by: dispose)
    }
}


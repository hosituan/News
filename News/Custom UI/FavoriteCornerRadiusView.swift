//
//  ConerRadiusView.swift
//  News
//
//  Created by Hồ Sĩ Tuấn on 8/4/20.
//  Copyright © 2020 Hồ Sĩ Tuấn. All rights reserved.
//

import UIKit


class FavoriteCornerRadiusView: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        let borderColor : UIColor = UIColor(rgb: 0xA0A5B5)
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1
        self.layer.borderColor = borderColor.cgColor
        self.isUserInteractionEnabled = true
        let tapView = UITapGestureRecognizer(target: self, action: #selector(FavoriteCornerRadiusView.tapView(sender:)))
        self.addGestureRecognizer(tapView)
        isFavoriteCategory()
    }
    @IBAction func tapView(sender: UITapGestureRecognizer) {
        let viewCategory = self.accessibilityIdentifier!
        if self.traitCollection.userInterfaceStyle == .dark {
            // User Interface is Dark
            updateBackgroundColor(#colorLiteral(red: 0.2370300889, green: 0.2448565066, blue: 0.3237020969, alpha: 1), #colorLiteral(red: 0.1254901961, green: 0.8039215686, blue: 0.5176470588, alpha: 1), viewCategory)
        } else if self.traitCollection.userInterfaceStyle == .light {
            // User Interface is Light
            updateBackgroundColor( #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), #colorLiteral(red: 0.1254901961, green: 0.8039215686, blue: 0.5176470588, alpha: 1), viewCategory)
        }
        
    }
    
    func updateBackgroundColor(_ fromColor: UIColor,_ toColor: UIColor,_ viewCategory: String) {
        let currentColor = self.backgroundColor?.rgb()!
        let fromColorRgb = fromColor.rgb()!
        if currentColor == fromColorRgb {
            //is disable
            print("is disable")
            favoriteCategory.append(viewCategory)
            coreDataManager.updateFavoriteCategory(favoriteCategory)
            self.backgroundColor = toColor
        } else {
            //is enable
            print("is enable")
            let newCategory = favoriteCategory.filter { $0 != viewCategory }
            print(newCategory)
            favoriteCategory = newCategory
            coreDataManager.updateFavoriteCategory(newCategory)
            self.backgroundColor = fromColor
        }
    }
    
    func isFavoriteCategory() {
        let viewCategory = self.accessibilityIdentifier!
        if favoriteCategory.contains(viewCategory) {
            self.backgroundColor = UIColor(rgb: 0x20CD84)
        }
    }
}

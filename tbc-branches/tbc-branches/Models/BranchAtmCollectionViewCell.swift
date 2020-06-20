//
//  BranchAtmCollectionViewCell.swift
//  tbc-branches
//
//  Created by Admin on 6/19/20.
//  Copyright © 2020 Mishka TBC. All rights reserved.
//

import UIKit

class BranchAtmCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var address: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = .white
        
        self.contentView.layer.cornerRadius = 5
        self.contentView.layer.borderWidth = 1
        self.contentView.layer.borderColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1).cgColor
        self.contentView.layer.masksToBounds = true

        self.layer.shadowColor = UIColor.black.withAlphaComponent(0.04).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 1
        self.layer.masksToBounds = false

    }
}

//
//  FilterCollectionViewCell.swift
//  real-estate
//
//  Created by Admin on 6/12/20.
//  Copyright © 2020 Mishka TBC. All rights reserved.
//

import UIKit

class FilterCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var filterCellLabel: UILabel!
    override var isSelected: Bool {
        didSet {
            
            self.layer.borderColor = isSelected ? UIColor(red: 216/255, green: 252/255, blue: 255/255, alpha: 1).cgColor : UIColor(red: 121/255, green: 144/255, blue: 246/255, alpha: 1).cgColor
            self.layer.backgroundColor = isSelected ? UIColor(red: 216/255, green: 252/255, blue: 255/255, alpha: 1).cgColor : UIColor.clear.cgColor
            filterCellLabel.textColor = isSelected ? UIColor(red: 108/255, green: 78/255, blue: 238/255, alpha: 1) : UIColor(red: 167/255, green: 215/255, blue: 252/255, alpha: 1)

        }
    }

}

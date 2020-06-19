//
//  HomeCollectionViewCell.swift
//  real-estate
//
//  Created by Admin on 6/12/20.
//  Copyright © 2020 Mishka TBC. All rights reserved.
//

import UIKit
import ShimmerBlocks

class HomeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var home_img: UIImageView!
    @IBOutlet weak var home_title: UILabel!
    @IBOutlet weak var home_price: UILabel!
    @IBOutlet weak var home_type: UILabel!
    @IBOutlet weak var bed_count: UILabel!
    @IBOutlet weak var bath_count: UILabel!
    @IBOutlet weak var sqr: UILabel!
    
    var isLoaded = false
    
    private lazy var shimmerContainer = ShimmerContainer(parentView: self)
    
    private lazy var shimmerData: [ShimmerData] = {
        return [ShimmerData(home_title, matchViewDimensions: true),
                ShimmerData(home_img, matchViewDimensions: true),
                ShimmerData(home_price, matchViewDimensions: true),
                ShimmerData(home_type, matchViewDimensions: true),
                ShimmerData(bed_count, matchViewDimensions: true),
                ShimmerData(bath_count, matchViewDimensions: true),
                ShimmerData(sqr, matchViewDimensions: true)]
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func isLoading(_ loading: Bool) {
        shimmerContainer.applyShimmer(enable: loading, with: shimmerData)
    }
    
}

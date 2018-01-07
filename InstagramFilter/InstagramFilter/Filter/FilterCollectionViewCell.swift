//
//  FilterCollectionViewCell.swift
//  InstagramFilter
//
//  Created by James Fong on 2018-01-05.
//  Copyright © 2018 James Fong. All rights reserved.
//

import UIKit

class FilterCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var filterNameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var initialLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureImageView()
    }
    
    func configureImageView() {
        let blur = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurredEffectView = UIVisualEffectView(effect: blur)
        blurredEffectView.alpha = 0.4
        blurredEffectView.frame = self.imageView.bounds
        self.imageView.addSubview(blurredEffectView)
    }

}

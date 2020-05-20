//
//  DataUsageCell.swift
//  sph
//
//  Created by Sujewan Vijayakumar on 5/18/20.
//  Copyright © 2020 sujewan. All rights reserved.
//

import UIKit

class DataUsageCell: UITableViewCell {

    @IBOutlet weak var stripeView: UIView!
    @IBOutlet weak var lblYear: UILabel!
    @IBOutlet weak var lblVolume: UILabel!
    @IBOutlet weak var imgAlert: UIImageView!

    private var viewModel: DataUsageItemViewModel!
    
    override func awakeFromNib() {
        self.stripeView.layer.cornerRadius = 8.0
        self.stripeView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
    }

    func updateCellUI(with viewModel: DataUsageItemViewModel) {
        self.viewModel = viewModel

        self.lblYear.text = viewModel.year
        self.lblVolume.text = viewModel.volume
        self.imgAlert.isHidden = viewModel.isAlertIconHidden
        self.stripeView.backgroundColor = viewModel.stripeColor
    }
}

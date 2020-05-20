//
//  DataUsageItemViewModel.swift
//  sph
//
//  Created by Sujewan Vijayakumar on 5/19/20.
//  Copyright © 2020 sujewan. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

struct DataUsageItemViewModel {
    let year: String
    let volume: String
    let isAlertIconHidden: Bool
    let stripeColor: UIColor
    var quarters = List<Quarter>()
}

extension DataUsageItemViewModel {

    init(record: YearlyRecord?) {
        self.year = record?.year.description ?? ""
        self.volume = record?.totalVolume.description ?? "0.0"
        self.isAlertIconHidden = !(record?.isDecreasedYear ?? false)
        self.stripeColor = record?.isDecreasedYear ?? false ? Colors.redBgColor : Colors.greenBgColor
        self.quarters = record?.quarters as! List<Quarter>
    }
}

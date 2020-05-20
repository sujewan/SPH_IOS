//
//  ResultsResponse.swift
//  sph
//
//  Created by Sujewan Vijayakumar on 5/18/20.
//  Copyright © 2020 sujewan. All rights reserved.
//

import Foundation
import Alamofire

struct ResultsResponse: Codable {
    var records: [Record]
}

//
//  DataUsageResponse.swift
//  sph
//
//  Created by Sujewan Vijayakumar on 5/18/20.
//  Copyright © 2020 sujewan. All rights reserved.
//

import Foundation
import Alamofire

struct DataUsageResponse: Codable, Equatable {

    let help: String
    let success: Bool
    let result: ResultsResponse

    static func == (lhs: DataUsageResponse, rhs: DataUsageResponse) -> Bool {
        return (lhs.help == rhs.help)
    }
}

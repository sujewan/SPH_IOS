//
//  APIManager.swift
//  sph
//
//  Created by Sujewan Vijayakumar on 5/18/20.
//  Copyright © 2020 sujewan. All rights reserved.
//

import Foundation
import Alamofire

public class APIManager {
    
    private let manager: Session

    init(manager: Session = Session.default) {
        self.manager = manager
    }

    func getMobileDataUsage(completion:@escaping (DataResponse<DataUsageResponse, AFError>) -> Void)  -> Cancellable? {
        return manager.request(APIRouter.getMobileDataUsage).responseDecodable { (response) in
             completion(response)
        } as? Cancellable
    }
}

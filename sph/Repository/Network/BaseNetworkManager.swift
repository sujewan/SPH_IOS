//
//  BaseNetworkManager.swift
//  sph
//
//  Created by Sujewan Vijayakumar on 5/18/20.
//  Copyright © 2020 sujewan. All rights reserved.
//

import Foundation
import Alamofire

class DictionaryEncoder {
    private let jsonEncoder = JSONEncoder()

    /// Encodes given Encodable value into an array or dictionary
    func encode<T>(_ value: T) throws -> Any where T: Encodable {
        let jsonData = try jsonEncoder.encode(value)
        return try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
    }
}

extension Encodable {
    var dictionary: [String: Any] {
        var param: [String: Any] = [: ]
        do {
            let param1 = try DictionaryEncoder().encode(self)
            param = param1 as! [String: Any]
        } catch {
            print("Couldnt parse parameter")
        }
        return param
    }
}

struct NetworkingConstants {
    static let baseUrl = "https://data.gov.sg/api/"
    static let resourceId = "a807b7ab-6cad-4aa6-87d0-e283a7353a0f"
}

protocol APIConfiguration: URLRequestConvertible {
    var method: HTTPMethod { get }
    var path: String { get }
    var body: [String: Any] { get }
    var headers: HTTPHeaders { get }
    var parameters: [String: Any] { get }
}

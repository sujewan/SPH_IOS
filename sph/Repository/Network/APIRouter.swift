//
//  APIRouter.swift
//  sph
//
//  Created by Sujewan Vijayakumar on 5/18/20.
//  Copyright © 2020 sujewan. All rights reserved.
//

import Foundation
import Alamofire

enum APIRouter: APIConfiguration {

    case getMobileDataUsage

    internal var method: HTTPMethod {
        switch self {
            case .getMobileDataUsage:
                return .get
        }
    }

    internal var path: String {
        switch self {
            case .getMobileDataUsage:
                return NetworkingConstants.baseUrl + "action/datastore_search?resource_id=" + NetworkingConstants.resourceId
        }
    }

    internal var parameters: [String: Any] {
        switch self {
        default: return [:]
        }
    }

    internal var body: [String: Any] {
        switch self {
        default: return [:]
        }
    }

    internal var headers: HTTPHeaders {
        switch self {
        default: return ["Content-Type": "application/json", "Accept": "application/json"]
        }
    }

    func asURLRequest() throws -> URLRequest {
        var urlComponents = URLComponents(string: path)!
        var queryItems: [URLQueryItem] = []
        for item in parameters {
            queryItems.append(URLQueryItem(name: item.key, value: "\(item.value)"))
        }
        if !(queryItems.isEmpty) {
            urlComponents.queryItems = queryItems
        }
        let url = urlComponents.url!
        var urlRequest = URLRequest(url: url)

        print("URL: \(url)")

        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = headers.dictionary

        if !(body.isEmpty) {
            urlRequest = try URLEncoding().encode(urlRequest, with: body)
            let jsonData1 = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
            urlRequest.httpBody = jsonData1
        }
        return urlRequest
    }
}

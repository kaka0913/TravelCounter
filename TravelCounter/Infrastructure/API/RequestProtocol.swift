//
//  RequestProtocol.swift
//  TravelCounter
//
//  Created by 株丹優一郎 on 2025/01/29.
//

import Alamofire
import Foundation

protocol RequestProtocol: Encodable {
    associatedtype Response: ResponseProtocol
    var baseUrl: String { get }
    var path: String { get }
    var method: Alamofire.HTTPMethod { get }
    var query: Parameters? { get }
    var encoding: Alamofire.ParameterEncoding { get }
    var parameters: Alamofire.Parameters? { get }
    var headers: Alamofire.HTTPHeaders? { get }
    var decoder: JSONDecoder { get }
}

extension RequestProtocol {
    var baseUrl: String {
        return "hogehoge" //TODO: BaseURLを置き換える
    }
    var encoding: Alamofire.ParameterEncoding {
        return JSONEncoding.default
    }
    var query: Parameters? {
        return nil
    }
    var parameters: Alamofire.Parameters? {
        return nil
    }
    var headers: Alamofire.HTTPHeaders? {
        return [
            "Content-Type": "application/json"
        ]
    }

    var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)

            let iso8601Formatter = ISO8601DateFormatter()
            if let date = iso8601Formatter.date(from: dateString) {
                return date
            }

            let customFormatter = DateFormatter()
            customFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            if let date = customFormatter.date(from: dateString) {
                return date
            }

            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Date string does not match any expected format.")
        }
        return decoder
    }
}

//
//  APIError.swift
//  TravelCounter
//
//  Created by 株丹優一郎 on 2025/01/29.
//

import Foundation

enum APIError: Error {
    case invalidResponse
    case decodingError(Error)
    case clientError(statusCode: Int, data: Data?)
    case serverError(statusCode: Int, data: Data?)
    case requestFailed(Error)
    case unknownError(statusCode: Int, data: Data?, error: Error)
}

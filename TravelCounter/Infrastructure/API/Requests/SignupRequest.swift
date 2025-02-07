//
//  SignupRequest.swift
//  TravelCounter
//
//  Created by 株丹優一郎 on 2025/02/07.
//

import Foundation
import Alamofire

struct SignupRequest: RequestProtocol {
    typealias Response = AuthResponse
    
    let userName: String
    let icon: String
    let authId: String
    
    var path: String {
        return "/auth/signup"
    }
    
    var method: HTTPMethod {
        return .post
    }
    
    var parameters: Parameters? {
        return [
            "user_name": userName,
            "icon": icon,
            "auth_id": authId
        ]
    }
}

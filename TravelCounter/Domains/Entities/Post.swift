//
//  Post.swift
//  TravelCounter
//
//  Created by 株丹優一郎 on 2025/02/05.
//

import Foundation
import MapKit

struct Post: Identifiable {
    let id: Int
    let userId: Int
    let userName: String
    let image: String
    let comment: String
    let date: Date
    let coordinate: CLLocationCoordinate2D
}

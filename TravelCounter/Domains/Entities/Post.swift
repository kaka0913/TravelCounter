//
//  Post.swift
//  TravelCounter
//
//  Created by 仲野将馬 on 2025/02/05.
//

import Foundation
import MapKit
import CoreLocation

struct Post: Identifiable {
    let id: Int
    let userId: Int
    let userName: String
    let image: String
    let comment: String
    let date: Date
    let coordinate: CLLocationCoordinate2D
    let prefectureId: String
    let groupIds: [Int]
}

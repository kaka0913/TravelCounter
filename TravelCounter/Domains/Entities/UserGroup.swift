//
//  UserGroup.swift
//  TravelCounter
//
//  Created by 株丹優一郎 on 2025/02/03.
//

struct UserGroup: Identifiable {
    let id: Int
    let name: String
    let imageURL: String?
    let users: [UserProfile]
    let password: String
}

//
//  Badge.swift
//  ShareUp
//
//  Created by 이가영 on 2021/05/23.
//

import Foundation

struct Badge: Codable {
    let first: Int
    let paper: Int
    let plastic: Int
    let glass: Int
    let styrofoam: Int
    let vinyl: Int
    let can: Int
    let clothing: Int
}

struct WritePost: Codable {
    let message: String
    let badgeInfo: BadgeInfo?
}

struct BadgeInfo: Codable {
    let category: String
    let level: Int
}

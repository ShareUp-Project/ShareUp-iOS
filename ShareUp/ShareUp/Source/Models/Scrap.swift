//
//  Scrap.swift
//  ShareUp
//
//  Created by 이가영 on 2021/04/13.
//

import Foundation

struct ScrapPost: Codable {
    let id: String
    let title: String
    let category: String
    let user: User
    let hashtags: [String]
    let images: [String]
    let scraps: Int
    let views: Int
}

struct Scrap: Codable {
    let data: [ScrapPost]
}

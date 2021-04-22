//
//  Detail.swift
//  ShareUp
//
//  Created by 이가영 on 2021/04/13.
//

import Foundation

struct DetailPost: Codable {
    let id: String
    let title: String
    let category: String
    let content: String
    let views: Int
    let user: User
    let images: [String]
    let scraps: Int
    let isScrap: Bool
    let isMine: Bool
}

struct Detail: Codable {
    let response: DetailPost
}

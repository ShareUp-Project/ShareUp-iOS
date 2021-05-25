//
//  Post.swift
//  ShareUp
//
//  Created by 이가영 on 2021/04/07.
//

import Foundation

struct Posts: Codable {
    let data: [Post]
}

struct Post: Codable {
    let id: String
    let title: String
    let category: String
    let views: Int
    let user: User
    let hashtags: [String]
    let images: [String]
    let scraps: Int
    let isScrap: Bool
}

struct User: Codable {
    let id: String
    let nickname: String
    let badgeCategory: String
    let badgeLevel: Int
}

struct WeeklyPosts: Codable {
    let id: String
    let title: String
}

struct WeeklyPost: Codable {
    let data: [WeeklyPosts]
}

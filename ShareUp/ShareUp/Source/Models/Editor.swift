//
//  Editor.swift
//  ShareUp
//
//  Created by 이가영 on 2021/05/03.
//

import Foundation

struct EditorPost: Codable {
    let id: String
    let title: String
    let content: String
    let image: String
}

struct Editor: Codable {
    let data: [EditorPost]
}

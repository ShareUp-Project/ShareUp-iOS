//
//  StatusRules.swift
//  ShareUp
//
//  Created by 이가영 on 2021/03/29.
//

import Foundation

enum StatusRules: Int {
    case ok = 200
    case created = 201
    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
    case conflict = 409
    case serverError = 500
    case fail = 0
}

//
//  TokenManager.swift
//  ShareUp
//
//  Created by 이가영 on 2021/03/31.
//

import Foundation

struct TokenManager {
    enum TokenSataus {
        case access
        case refresh
    }
    
    static var currentToken: Tokens? {
        return StoregaeManager.shared.read()
    }
    
    static func accessTokenisUseful() -> Bool {
        if (currentToken?.accessToken) != nil {
            return true
        }else {
            return false
        }
    }
    
    static func refreshTokenisUseful() -> Bool {
        if (currentToken?.refreshToken) != nil {
            return true
        }else {
            return false
        }
    }
    
    static func removeToken() {
        StoregaeManager.shared.delete()
    }
    
}

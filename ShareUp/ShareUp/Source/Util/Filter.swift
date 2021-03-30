//
//  Filter.swift
//  ShareUp
//
//  Created by 이가영 on 2021/03/30.
//

import Foundation

struct ShareUpFilter {
    static func checkPassword(_ pw: String) -> Bool {
        return pw.range(of: "/^(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}$/", options: .regularExpression) != nil
    }
    
    static func checkPhoneCount(_ phone: String) -> Bool {
        return phone.count >= 11
    }
}

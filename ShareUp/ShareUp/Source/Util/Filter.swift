//
//  Filter.swift
//  ShareUp
//
//  Created by 이가영 on 2021/03/30.
//

import Foundation

struct ShareUpFilter {
    static func checkPassword(_ pw: String) -> Bool {
        return pw.range(of: "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}$", options: .regularExpression) != nil
    }
    
    static func filterCategory(_ category: String) -> String {
        switch category {
        case "유리" : return "glass"
        case "플라스틱" : return "plastic"
        case "종이" : return "paper"
        case "스티로폼" : return "styroform"
        case "캔" : return "can"
        case "비닐" : return "vinyl"
        case "의류" : return "clothing"
        case "기타" : return "etc"
        default: return ""
        }
    }
}

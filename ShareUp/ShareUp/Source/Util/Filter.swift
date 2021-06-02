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
        case "스티로폼" : return "styrofoam"
        case "캔" : return "can"
        case "비닐" : return "vinyl"
        case "의류" : return "clothing"
        case "기타" : return "etc"
        default: return ""
        }
    }
    
    static func filterCategorySearch(_ number: Int) -> String {
        switch number {
        case 1 : return "paper"
        case 2 : return "vinyl"
        case 3 : return "can"
        case 4 : return "plastic"
        case 5 : return "glass"
        case 6 : return "styrofoam"
        case 7 : return "clothing"
        case 8 : return "etc"
        default: return ""
        }
    }
    
    static func filterCategoryBadge(_ number: Int) -> String {
        switch number {
        case 0 : return "default"
        case 1: return "first"
        case 2 : return "paper"
        case 3 : return "plastic"
        case 4 : return "glass"
        case 5 : return "styrofoam"
        case 6 : return "vinyl"
        case 7 : return "can"
        case 8 : return "clothing"
        default: return ""
        }
    }
    
    static func filterCurrentBadge(_ str: String) -> Int {
        switch str {
        case "default" : return 0
        case "first": return 1
        case "paper" : return 2
        case "plastic" : return 3
        case "glass" : return 4
        case "styrofoam" : return 5
        case "vinyl" : return 6
        case "can" : return 7
        case "clothing": return 8
        default: return 0
        }
    }
}

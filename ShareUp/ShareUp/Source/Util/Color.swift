//
//  Color.swift
//  ShareUp
//
//  Created by 이가영 on 2021/03/24.
//

import UIKit

protocol Point {
    static func pointHex(hex: String) -> UIColor
}

extension Point {
    static func pointHex(hex: String) -> UIColor {
        var rgbValue: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&rgbValue)
        return UIColor(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                       green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                       blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                       alpha: CGFloat(1.0)
        )
    }
}

struct MainColor: Point {
    static let red = pointHex(hex: "EB5757")
    static let gray01 = pointHex(hex: "F6F6F6")
    static let gray02 = pointHex(hex: "E8E8E8")
    static let gray03 = pointHex(hex: "BDBDBD")
    static let gray04 = pointHex(hex: "666666")
    static let primaryGreen = pointHex(hex: "5DB075")
    static let secondaryGreen = pointHex(hex: "4B9460")
    static let defaultGreen = pointHex(hex: "59B57D")
}

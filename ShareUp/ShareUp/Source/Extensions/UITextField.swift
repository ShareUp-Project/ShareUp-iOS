//
//  UITextFIeld.swift
//  ShareUp
//
//  Created by 이가영 on 2021/03/31.
//

import UIKit

extension UITextField {
    func checkPhoneCount(_ id: String) {
        if id.count > 11 {
            let index = id.index(id.startIndex, offsetBy: 6)
            text = String(id[..<index])
        }
    }
}

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
            let index = id.index(id.startIndex, offsetBy: 11)
            text = String(id[..<index])
        }
    }
    
    func checkNicknameCount(_ nickname: String) {
        if nickname.count > 10 {
            let index = nickname.index(nickname.startIndex, offsetBy: 10)
            text = String(nickname[..<index])
        }
    }
    
    func disableAutoFill() {
        if #available(iOS 12, *) {
            textContentType = .oneTimeCode
        } else {
            textContentType = .init(rawValue: "")
        }
    }
}

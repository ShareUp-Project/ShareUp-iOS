//
//  UIViewController.swift
//  ShareUp
//
//  Created by 이가영 on 2021/03/28.
//

import UIKit

extension UIViewController {
    func checkTimer(_ timer: Int) -> String {
        let seconds: Int = timer % 60
        let minutes: Int = (timer / 60) % 60
        return String(format: "%0d:%02d", minutes, seconds)
    }
}

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
    
    func pushViewController(_ identifier: String) {
        let vc = storyboard?.instantiateViewController(withIdentifier: identifier)
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    func navigationBarColor(_ color: UIColor) {
        let backButton: UIBarButtonItem = UIBarButtonItem()
        backButton.title = "뒤로"
        backButton.tintColor = MainColor.primaryGreen
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.backgroundColor = color
        navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
//        navigationController?.navigationBar.topItem?.title = title
    }
    
    func navigationBarHidden() {
        navigationController?.isNavigationBarHidden = true
    }
}

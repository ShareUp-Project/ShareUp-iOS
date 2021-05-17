//
//  TabBarViewController.swift
//  ShareUp
//
//  Created by 이가영 on 2021/04/21.
//

import UIKit

final class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.viewControllers = [self]
    }
}

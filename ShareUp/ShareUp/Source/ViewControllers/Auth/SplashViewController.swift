//
//  SplashViewController.swift
//  ShareUp
//
//  Created by 이가영 on 2021/03/31.
//

import UIKit

final class SplashViewController: UIViewController {
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBarHidden()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationBarHidden()
    }
}

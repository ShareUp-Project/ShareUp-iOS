//
//  SerachViewController.swift
//  ShareUp
//
//  Created by 이가영 on 2021/04/27.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet var categoryView: [UIView]!
    @IBOutlet var categoryTouchArea: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let cancel = UIBarButtonItem(title: "취소", style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem = cancel
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 320, height: 0))
        searchBar.placeholder = "검색"
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchBar)
        
        navigationBackCustom()
    }
}

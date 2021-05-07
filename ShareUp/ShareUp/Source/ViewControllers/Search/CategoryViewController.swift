//
//  CategoryViewController.swift
//  ShareUp
//
//  Created by 이가영 on 2021/04/16.
//

import UIKit

class CategoryViewController: UIViewController {

    @IBOutlet var categorys: [UIButton]!
    
    var delegate: DismissSendData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationBackCustom()
    }
    
    @IBAction func clickCategory(_ sender: UIButton) {
        delegate?.dismissData((sender.titleLabel?.text)!)
        navigationController?.popViewController(animated: true)
    }

}

protocol DismissSendData {
    func dismissData(_ data: String)
}

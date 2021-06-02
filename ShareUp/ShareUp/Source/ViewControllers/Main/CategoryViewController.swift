//
//  CategoryViewController.swift
//  ShareUp
//
//  Created by 이가영 on 2021/04/16.
//

import UIKit

final class CategoryViewController: UIViewController {
    //MARK: UI
    @IBOutlet var categorys: [UIButton]!
    
    //MARK: Properties
    var delegate: DismissSendData?
    
    //MARK: LifeCtcle
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

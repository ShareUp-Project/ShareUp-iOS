//
//  CertifyViewController.swift
//  ShareUp
//
//  Created by 이가영 on 2021/03/28.
//

import UIKit
import SwiftyTimer
import RxSwift
import RxCocoa

class CertifyViewController: UIViewController {

    @IBOutlet weak var countCertifyLabel: UILabel!
    @IBOutlet weak var certifyRequestButton: UIButton!
    @IBOutlet weak var numberTextField: AuthTextField!
    @IBOutlet weak var authNumberTextField: AuthTextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var certifyButton: UIButton!
    
    private var disposeBag = DisposeBag()
    private var countDown: Int = 180 {
        willSet {
            countCertifyLabel.text = checkTimer(countDown)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        numberTextField.rx.text.orEmpty.subscribe(onNext: {[unowned self] text in numberTextField.checkPhoneCount(text)}).disposed(by: disposeBag)
        certifyRequestButton.rx.tap.subscribe(onNext: {[unowned self ] _ in countCertifyLabel.isHidden = false}).disposed(by: disposeBag)
        
        let timer = Timer.new(every: 1.second) { [unowned self] _ in countDown -= 1 }
        certifyRequestButton.rx.tap.subscribe(onNext: {[unowned self] _ in
            if countDown < 0 { timer.invalidate() }
            timer.start()
        })
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

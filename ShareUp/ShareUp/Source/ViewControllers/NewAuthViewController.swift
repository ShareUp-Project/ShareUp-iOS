//
//  NewAuthViewController.swift
//  ShareUp
//
//  Created by 이가영 on 2021/04/01.
//

import UIKit
import RxSwift
import RxCocoa

class NewAuthViewController: UIViewController {

    @IBOutlet weak var newTextField: AuthTextField!
    @IBOutlet weak var securityOnOffButton: UIButton!
    @IBOutlet weak var checkTextField: AuthTextField!
    @IBOutlet weak var equalsButton: UILabel!
    @IBOutlet weak var resetButton: UIButton!
    
    private let viewModel = NewAuthViewModel()
    private let disposeBag = DisposeBag()
    var phoneNumber = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        managerTrait()
        bindViewModel()
    }
    
    private func bindViewModel() {
        let input = NewAuthViewModel.Input(phoneNum: Driver.just(phoneNumber),
                                           newPassword: newTextField.rx.text.orEmpty.asDriver(),
                                           againPassword: checkTextField.rx.text.orEmpty.asDriver(),
                                           resetTap: resetButton.rx.tap.asDriver())
        let output = viewModel.transform(input)
        
        output.isEquals.drive{[unowned self] value in
            equalsButton.text = value ? "일치" : "불일치"
            equalsButton.textColor = value ? MainColor.primaryGreen : MainColor.red
        }.disposed(by: disposeBag)
        
    }
    
    private func managerTrait() {
        securityOnOffButton.rx.tap.asDriver{ _ in .never() }.drive(onNext: { [weak self] in self?.updateCurrentStatus() }).disposed(by: disposeBag)
    }
    
    private func updateCurrentStatus() {
        newTextField.isSecureTextEntry.toggle()
        securityOnOffButton.setTitle(newTextField.isSecureTextEntry ? "보기" : "숨기기", for: .normal)
    }
}

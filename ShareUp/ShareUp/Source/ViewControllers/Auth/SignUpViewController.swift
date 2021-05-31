//
//  SignUpViewController.swift
//  ShareUp
//
//  Created by 이가영 on 2021/03/31.
//

import UIKit
import RxSwift
import RxCocoa
import SPAlert

final class SignUpViewController: UIViewController {
    //MARK: UI
    @IBOutlet weak var nicknameTextField: AuthTextField!
    @IBOutlet weak var passwordTextField: AuthTextField!
    @IBOutlet weak var securityOnOffButton: UIButton!
    @IBOutlet weak var signUpButton: HighlightedButton!
    @IBOutlet weak var duplicateLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    
    //MARK: Properties
    private let disposeBag = DisposeBag()
    private let viewModel = SignUpViewModel()
    var phoneNumber = String()
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        managerTrait()
        bindViewModel()
        navigationBarColor(.white)
        passwordTextField.disableAutoFill()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        title = "회원가입"
    }
    
    //MARK: Bind
    private func bindViewModel() {
        let input = SignUpViewModel.Input(phone: Driver.just(phoneNumber),
                                          nickname: nicknameTextField.rx.text.orEmpty.asDriver(),
                                          password: passwordTextField.rx.text.orEmpty.asDriver(),
                                          doneTap: signUpButton.rx.tap.asDriver())
        let output = viewModel.transform(input)
        
        output.duplicateCheck.emit(onNext: { [unowned self] error in
            duplicateLabel.isHidden = false
            duplicateLabel.text = error
        },onCompleted: { [unowned self] in
            duplicateLabel.text = "가능"
            duplicateLabel.textColor = MainColor.primaryGreen
            output.result.emit(onNext: { [unowned self] error in
                errorLabel.isHidden = false
                errorLabel.text = error
            }, onCompleted: {
                let alertView = SPAlertView(title: "성공", message: "회원가입이 완료되었습니다.", preset: .done)
                alertView.present(duration: 1.5, haptic: .success) {
                    pushViewController("signin")
                }
            }).disposed(by: disposeBag)
        }).disposed(by: disposeBag)
        
        output.errorIsHidden.drive(errorLabel.rx.isHidden).disposed(by: disposeBag)
        
    }
    
    //MARK: Rx Action
    private func managerTrait() {
        securityOnOffButton.rx.tap.asDriver{ _ in .never() }.drive(onNext: { [weak self] in self?.updateCurrentStatus() }).disposed(by: disposeBag)
    }
    
    private func updateCurrentStatus() {
        passwordTextField.isSecureTextEntry.toggle()
        securityOnOffButton.setTitle(passwordTextField.isSecureTextEntry ? "보기" : "숨기기", for: .normal)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

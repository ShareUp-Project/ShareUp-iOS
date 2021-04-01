//
//  ViewController.swift
//  ShareUp
//
//  Created by 이가영 on 2021/03/24.
//

import UIKit
import RxSwift
import RxCocoa
import GoogleSignIn

class SignInViewController: UIViewController {

    @IBOutlet weak var authTextField: AuthTextField!
    @IBOutlet weak var passwordTextField: AuthTextField!
    @IBOutlet weak var googleAuthButton: GIDSignInButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var signInButton: HighlightedButton!
    @IBOutlet weak var autoAuthButton: UIButton!
    @IBOutlet weak var securityOnOffButton: UIButton!
    
    private let disposeBag = DisposeBag()
    private let viewModel = SignInViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        navigationBarColor(.white)
        managerTrait()
    }
    
    private func bindViewModel() {
        let input = SignInViewModel.Input(phone: authTextField.rx.text.orEmpty.asDriver(),
                                          password: passwordTextField.rx.text.orEmpty.asDriver(),
                                          doneTap: signInButton.rx.tap.asDriver())
        let output = viewModel.transform(input)
        
    }
    
    private func managerTrait() {
        securityOnOffButton.rx.tap.asDriver{ _ in .never() }.drive(onNext: { [weak self] in self?.updateCurrentStatus() }).disposed(by: disposeBag)
        autoAuthButton.rx.tap.asDriver{ _ in .never() }.drive(onNext: { [weak self] in self?.autoAuthButton.isSelected.toggle() }).disposed(by: disposeBag)
        authTextField.rx.text.orEmpty.subscribe(onNext: {[unowned self] text in authTextField.checkPhoneCount(text)}).disposed(by: disposeBag)
    }
    
    private func updateCurrentStatus() {
        passwordTextField.isSecureTextEntry.toggle()
        securityOnOffButton.setTitle(passwordTextField.isSecureTextEntry ? "보기" : "숨기기", for: .normal)
    }
}


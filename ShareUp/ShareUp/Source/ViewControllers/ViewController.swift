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

class ViewController: UIViewController {

    @IBOutlet weak var authTextField: AuthTextField!
    @IBOutlet weak var passwordTextField: AuthTextField!
    @IBOutlet weak var googleAuthButton: GIDSignInButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var autoAuthButton: UIButton!
    @IBOutlet weak var securityOnOffButton: UIButton!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        securityOnOffButton.rx.tap.asDriver{ _ in .never() }.drive(onNext: { [weak self] in self?.updateCurrentStatus() }).disposed(by: disposeBag)
    }
    
    private func updateCurrentStatus() {
        passwordTextField.isSecureTextEntry.toggle()
        securityOnOffButton.setTitle(passwordTextField.isSecureTextEntry ? "숨기기" : "보기", for: .normal)
    }
}


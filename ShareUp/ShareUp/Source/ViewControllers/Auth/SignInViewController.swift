//
//  ViewController.swift
//  ShareUp
//
//  Created by 이가영 on 2021/03/24.
//

import UIKit
import RxSwift
import RxCocoa

final class SignInViewController: UIViewController {
    //MARK: UI
    @IBOutlet weak var authTextField: AuthTextField!
    @IBOutlet weak var passwordTextField: AuthTextField!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var signInButton: HighlightedButton!
    @IBOutlet weak var autoAuthButton: UIButton!
    @IBOutlet weak var securityOnOffButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var securityTextButton: UIButton!

    //MARK: Properties
    private let disposeBag = DisposeBag()
    private let viewModel = SignInViewModel()
    private let setAutoLogin = BehaviorRelay<Void>(value: ())
    private let autoIsSelect = BehaviorRelay<Bool>(value: false)
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        navigationBarColor(.white)
        managerTrait()
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: Bind
    private func bindViewModel() {
        let input = SignInViewModel.Input(setAutoLogin: setAutoLogin.asDriver(),
                                          phone: authTextField.rx.text.orEmpty.asDriver(),
                                          password: passwordTextField.rx.text.orEmpty.asDriver(),
                                          isAuto: autoIsSelect.asDriver(onErrorJustReturn: false),
                                          doneTap: signInButton.rx.tap.asDriver())
        let output = viewModel.transform(input)
        
        output.result.emit(onNext: {[unowned self] error in
            errorLabel.isHidden = false
            errorLabel.text = error
        }, onCompleted: {[unowned self] in
            pushViewController("main")
        }).disposed(by: disposeBag)
        
        output.auto.emit(onCompleted: { [unowned self] in
            pushViewController("main")
        }).disposed(by: disposeBag)
    }
    
    //MARK: Rx Action
    private func managerTrait() {
        securityOnOffButton.rx.tap.asDriver{ _ in .never() }.drive(onNext: { [weak self] in self?.updateCurrentStatus()
        }).disposed(by: disposeBag)
        autoAuthButton.rx.tap.asDriver{ _ in .never() }.drive(onNext: { [weak self] in self?.autoAuthButton.isSelected.toggle()
        }).disposed(by: disposeBag)
        authTextField.rx.text.orEmpty.subscribe(onNext: {[unowned self] text in authTextField.checkPhoneCount(text)
        }).disposed(by: disposeBag)
        autoAuthButton.rx.tap.subscribe(onNext:{ [unowned self] in
            autoIsSelect.accept(autoAuthButton.isSelected)
        }).disposed(by: disposeBag)
        securityTextButton.rx.tap.subscribe(onNext: { [unowned self] in
            autoIsSelect.accept(autoAuthButton.isSelected)
        }).disposed(by: disposeBag)
        securityTextButton.rx.tap.asDriver{ _ in .never() }.drive(onNext: { [weak self] in self?.autoAuthButton.isSelected.toggle()
        }).disposed(by: disposeBag)
    }

    private func updateCurrentStatus() {
        passwordTextField.isSecureTextEntry.toggle()
        securityOnOffButton.setTitle(passwordTextField.isSecureTextEntry ? "보기" : "숨기기", for: .normal)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}


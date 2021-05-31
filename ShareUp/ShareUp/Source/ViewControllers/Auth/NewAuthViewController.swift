//
//  NewAuthViewController.swift
//  ShareUp
//
//  Created by 이가영 on 2021/04/01.
//

import UIKit
import RxSwift
import RxCocoa
import SPAlert

final class NewAuthViewController: UIViewController {
    //MARK: UI
    @IBOutlet weak var newTextField: AuthTextField!
    @IBOutlet weak var securityOnOffButton: UIButton!
    @IBOutlet weak var checkTextField: AuthTextField!
    @IBOutlet weak var equalsButton: UILabel!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    //MARK: Properties
    private let viewModel = NewAuthViewModel()
    private let disposeBag = DisposeBag()
    var phoneNumber = String()
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        managerTrait()
        navigationBarColor(.white)
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        title = "비밀번호 초기화"
    }
    
    //MARK: Bind
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
        
        output.result.emit(onNext: {[unowned self] error in
            errorLabel.isHidden = false
            errorLabel.text = error
        },onCompleted: { [unowned self] in
            view.endEditing(true)
            let alertView = SPAlertView(title: "성공", message: "초기화가 완료되었습니다.", preset: .done)
            alertView.present(duration: 1.5, haptic: .success) {
                pushViewController("signin")
            }
        }).disposed(by: disposeBag)
        
        output.errorIsHidden.drive(errorLabel.rx.isHidden).disposed(by: disposeBag)
    }
    
    //MARK: Rx Action
    private func managerTrait() {
        securityOnOffButton.rx.tap.asDriver{ _ in .never() }.drive(onNext: { [weak self] in self?.updateCurrentStatus() }).disposed(by: disposeBag)
    }
    
    private func updateCurrentStatus() {
        newTextField.isSecureTextEntry.toggle()
        securityOnOffButton.setTitle(newTextField.isSecureTextEntry ? "보기" : "숨기기", for: .normal)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

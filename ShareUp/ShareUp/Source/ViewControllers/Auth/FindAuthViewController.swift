//
//  FindAuthViewController.swift
//  ShareUp
//
//  Created by 이가영 on 2021/03/31.
//

import UIKit
import RxSwift
import RxCocoa

final class FindAuthViewController: UIViewController {
    //MARK: UI
    @IBOutlet weak var countCertifyLabel: UILabel!
    @IBOutlet weak var certifyRequestButton: UIButton!
    @IBOutlet weak var numberTextField: AuthTextField!
    @IBOutlet weak var authNumberTextField: AuthTextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var certifyButton: HighlightedButton!
    
    //MARK: Properties
    private let viewModel = FindAuthViewModel()
    private var disposeBag = DisposeBag()
    private var countDown: Int = 180 {
        willSet {
            if countDown < 0 { countCertifyLabel.isHidden = true }
            countCertifyLabel.text = checkTimer(countDown)
        }
    }

    //MARK: UI
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        navigationBarColor(.white)
        managerTrait()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        countDown = 1
    }
    
    //MAKR: Bind
    private func bindViewModel() {
        let input = FindAuthViewModel.Input(phoneNum: numberTextField.rx.text.orEmpty.asDriver(),
                                           phoneRequest: certifyRequestButton.rx.tap.asDriver(),
                                           phoneCertify: authNumberTextField.rx.text.orEmpty.asDriver(),
                                           certifyButton: certifyButton.rx.tap.asDriver())
        let output = viewModel.transform(input)
        let timer = Timer.new(every: 1.second) {[unowned self] time in
            if countDown == 0 { time.invalidate() }
            countDown -= 1
        }
        
        output.wait.emit(onNext: { [unowned self] error in
                            errorLabel.text = error
                            errorLabel.isHidden = false},
                         onCompleted: {[unowned self] in
                            errorLabel.isHidden = true
                            countCertifyLabel.isHidden = false
                            timer.start()
                         }).disposed(by: disposeBag)
        
        output.result.emit(onNext: { [unowned self] error in
                            errorLabel.text = error
                            errorLabel.isHidden.toggle()},
                           onCompleted: {[unowned self] in
                            let vc = storyboard?.instantiateViewController(withIdentifier: "newPassword") as! NewAuthViewController
                            vc.phoneNumber = numberTextField.text!
                            timer.invalidate()
                            navigationController?.pushViewController(vc, animated: true)
                           }).disposed(by: disposeBag)
    }
    
    //MARK:Rx Action
    private func managerTrait() {
        certifyRequestButton.rx.tap.subscribe(onNext: {[unowned self] _ in
            certifyRequestButton.setTitle("재요청", for: .normal)
            countDown = 180
        }).disposed(by: disposeBag)
        
        numberTextField.rx.text.orEmpty.subscribe(onNext: {[unowned self] text in numberTextField.checkPhoneCount(text)}).disposed(by: disposeBag)

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

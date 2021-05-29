//
//  ChangeNameViewController.swift
//  ShareUp
//
//  Created by 이가영 on 2021/05/07.
//

import UIKit
import RxSwift
import RxCocoa

final class ChangeNameViewController: UIViewController {
    //MARK: UI
    @IBOutlet weak var nicknameTextField: AuthTextField!
    @IBOutlet weak var changeButton: HighlightedButton!
    @IBOutlet weak var duplicateLabel: UILabel!

    //MARK: Properties
    private let disposeBag = DisposeBag()
    private let viewModel = ChangeNameViewModel()
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.navigationController?.navigationItem.title = "닉네임 수정"
        navigationBackCustom()
    }
    
    //MARK: Bind
    private func bindViewModel() {
        let input = ChangeNameViewModel.Input(nickname: nicknameTextField.rx.text.orEmpty.asDriver(),
                                              doneTap: changeButton.rx.tap.asDriver())
        let output = viewModel.transform(input)
        
        output.duplicateCheck.emit(onNext: { [unowned self] error in
            duplicateLabel.isHidden = false
            duplicateLabel.text = error
        },onCompleted: { [unowned self] in
            navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
    }
}

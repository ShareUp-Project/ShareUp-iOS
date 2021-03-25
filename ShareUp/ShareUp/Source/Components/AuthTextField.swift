//
//  AuthTextField.swift
//  ShareUp
//
//  Created by 이가영 on 2021/03/24.
//

import UIKit
import RxSwift
import RxCocoa

class AuthTextField: UITextField {

    private let disposeBag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        controlTextField()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
       controlTextField()
    }
    
    func controlTextField() {
        endEditingTextField()
        font = UIFont(name: Font.nsM.rawValue, size: 16)
        rx.controlEvent(.allEditingEvents).subscribe(onNext: {[unowned self] _ in editingTextField() }).disposed(by: disposeBag)
        rx.controlEvent(.editingDidEnd).subscribe(onNext: {[unowned self] _ in endEditingTextField() }).disposed(by: disposeBag)
        layer.cornerRadius = 8
    }
    
    func editingTextField() {
        layer.borderColor = MainColor.secondaryGreen.cgColor
        layer.borderWidth = 1
        backgroundColor = .white
    }
    
    func endEditingTextField() {
        backgroundColor = MainColor.gray01
        layer.borderColor = MainColor.gray02.cgColor
        layer.borderWidth = 1
    }
}

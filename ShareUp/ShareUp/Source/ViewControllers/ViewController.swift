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
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}


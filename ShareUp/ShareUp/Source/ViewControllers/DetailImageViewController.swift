//
//  DetailImageViewController.swift
//  ShareUp
//
//  Created by 이가영 on 2021/04/23.
//

import UIKit
import RxSwift

class DetailImageViewController: UIViewController {

    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var dismissButton: UIButton!
    
    var sendImage = String()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        detailImageView.kf.setImage(with: URL(string: "https://shareup-bucket.s3.ap-northeast-2.amazonaws.com/" + sendImage)!)
        dismissButton.rx.tap.subscribe(onNext: {[unowned self] _ in
            dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
    }

}

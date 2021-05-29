//
//  DetailImageViewController.swift
//  ShareUp
//
//  Created by 이가영 on 2021/04/23.
//

import UIKit
import RxSwift

final class DetailImageViewController: UIViewController {
    //MARK: UI
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var pinch: UIPinchGestureRecognizer!
    
    //MARK: Properties
    var sendImage = String()
    private let disposeBag = DisposeBag()
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailImageView.kf.setImage(with: URL(string: "https://shareup-bucket.s3.ap-northeast-2.amazonaws.com/" + sendImage)!)
        dismissButton.rx.tap.subscribe(onNext: {[unowned self] _ in
            dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
    }
    
    @IBAction func pinchImageGesture(_ sender: Any) {
        detailImageView.transform = detailImageView.transform.scaledBy(x: pinch.scale, y: pinch.scale)
        pinch.scale = 1.0
    }
}

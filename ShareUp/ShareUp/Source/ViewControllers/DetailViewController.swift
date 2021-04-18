//
//  DetailViewController.swift
//  ShareUp
//
//  Created by 이가영 on 2021/04/11.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class DetailViewController: UIViewController {

    @IBOutlet weak var shareImageView: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var badgeImageView: UIImageView!
    @IBOutlet weak var nicknameButton: UIButton!
    @IBOutlet weak var scrapButton: UIButton!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var viewsLabel: UILabel!
    @IBOutlet weak var scrapsLabel: UILabel!
    
    var detailId = String()
    private let disposeBag = DisposeBag()
    private let viewModel = DetailViewModel()
    private var loadData = BehaviorRelay<Void>(value: ())
    private var image = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(detailId)
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        loadData.accept(())
    }
    
    @IBAction func setPaging(_ sender: Any) {
        shareImageView.kf.setImage(with: URL(string: "https://shareup-s3.s3.ap-northeast-2.amazonaws.com/\(image[pageControl.currentPage])")!)
    }
    
    private func bindViewModel() {
        let input = DetailViewModel.Input(getDetail: loadData.asSignal(onErrorJustReturn: ()),
                                          detailPostId: detailId, postScrap: scrapButton.rx.tap.asDriver())
        let output = viewModel.transform(input)
        
        output.getDetail.bind {[unowned self] data in
            print(data.images[0])
            pageControl.numberOfPages = data.images.count
            shareImageView.kf.setImage(with: URL(string: "https://shareup-s3.s3.ap-northeast-2.amazonaws.com/\(data.images[0])")!)
            image = data.images
            titleLabel.text = data.title
            nicknameButton.setTitle(data.user.nickname, for: .normal)
            scrapButton.isSelected = data.isScrap
            contentTextView.text = data.content
            viewsLabel.text = String(data.views)
            scrapsLabel.text = String(data.scraps)
            if data.isMine {
                navigationItem.rightBarButtonItem = deletePostButton
            }
        }.disposed(by: disposeBag)
        
        output.scrapResult.asObservable().subscribe(onNext: {[unowned self] _ in
            loadData.accept(())
        }).disposed(by: disposeBag)
        
        output.result.emit(onCompleted : {
            self.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
    }
    
    private func setPagingGesture() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(_:)))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(_:)))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
    }
    
    @objc func respondToSwipeGesture(_ gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer{
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.left :
                pageControl.currentPage += 1
                shareImageView.kf.setImage(with: URL(string: "https://shareup-s3.s3.ap-northeast-2.amazonaws.com/\(image[pageControl.currentPage])")!)
            case UISwipeGestureRecognizer.Direction.right :
                pageControl.currentPage -= 1
                shareImageView.kf.setImage(with: URL(string: "https://shareup-s3.s3.ap-northeast-2.amazonaws.com/\(image[pageControl.currentPage])")!)
            default:
                break
            }
        }
    }

}

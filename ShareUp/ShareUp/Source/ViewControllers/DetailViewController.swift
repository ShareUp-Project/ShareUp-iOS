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
        }.disposed(by: disposeBag)
        
        output.scrapResult.asObservable().subscribe(onNext: {[unowned self] _ in
            loadData.accept(())
        }).disposed(by: disposeBag)
    }
    
}

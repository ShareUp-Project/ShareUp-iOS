//
//  TestViewController.swift
//  ShareUp
//
//  Created by 이가영 on 2021/04/21.
//

import UIKit
import AdvancedPageControl
import RxSwift
import RxCocoa
import ActiveLabel
import Kingfisher

class TestViewController: UIViewController {

    @IBOutlet weak var pictureCollectionView: UICollectionView!
    @IBOutlet weak var pageController: AdvancedPageControlView!
    @IBOutlet weak var shareImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var badgeImageView: UIImageView!
    @IBOutlet weak var nicknameButton: UIButton!
    @IBOutlet weak var scrapButton: UIButton!
    @IBOutlet weak var contentTextView: ActiveLabel!
    @IBOutlet weak var viewsLabel: UILabel!
    @IBOutlet weak var scrapsLabel: UILabel!
    
    lazy var deletePostButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "삭제", style: .plain, target: self, action: nil)
        button.tintColor = MainColor.red
        return button
    }()
    var imageFile = ["detail", "selectDetail", "SelectVector", "Vector"]
    var detailId = String()
    private let disposeBag = DisposeBag()
    private let viewModel = DetailViewModel()
    private var loadData = BehaviorRelay<Void>(value: ())
    private var image = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageController.drawer = ExtendedDotDrawer(numberOfPages: 0, space: 10.0, indicatorColor: MainColor.primaryGreen, dotsColor: MainColor.gray02, isBordered: false, borderWidth: 0.0, indicatorBorderColor: .clear, indicatorBorderWidth: 0.0)
        
        pictureCollectionView.dataSource = self
        pictureCollectionView.delegate = self
        
        contentTextView.numberOfLines = 0
        contentTextView.enabledTypes = [.hashtag]
        contentTextView.font = UIFont(name: "Noto Sans KR", size: 16)
        bindViewModel()
        
        pageController.numberOfPages = imageFile.count
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        loadData.accept(())
        navigationBackCustom()
    }
    
    private func bindViewModel() {
        let input = DetailViewModel.Input(getDetail: loadData.asSignal(onErrorJustReturn: ()),
                                          detailPostId: detailId, postScrap: scrapButton.rx.tap.asDriver(),
                                          deletePost: deletePostButton.rx.tap.asDriver())
        let output = viewModel.transform(input)
        
        output.getDetail.bind {[unowned self] data in
            shareImageView.kf.setImage(with: URL(string: "https://shareup-bucket.s3.ap-northeast-2.amazonaws.com/\(data.images[0])")!)
            image = data.images
            titleLabel.text = data.title
            nicknameButton.setTitle(data.user.nickname, for: .normal)
            scrapButton.isSelected = data.isScrap
            contentTextView.text = data.content
            viewsLabel.text = String(data.views)
            scrapsLabel.text = String(data.scraps)
            if data.isMine { navigationItem.rightBarButtonItem = deletePostButton }
        }.disposed(by: disposeBag)
        
        output.scrapResult.asObservable().subscribe(onNext: {[unowned self] _ in
            loadData.accept(())
        }).disposed(by: disposeBag)
        
        output.result.emit(onCompleted : {
            self.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
    }

}

class DetailCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var detailImageView: UIImageView!
    
}

extension TestViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageFile.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "scrollCell", for: indexPath) as! DetailCollectionViewCell
        
        cell.detailImageView.image = UIImage(named: imageFile[indexPath.row])
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSet = scrollView.contentOffset.x
        let width = scrollView.frame.width
        
        pageController.setPageOffset(offSet / width)
    }
}

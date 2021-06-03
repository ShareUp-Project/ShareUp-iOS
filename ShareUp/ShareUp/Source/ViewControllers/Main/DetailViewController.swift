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
import Lottie

final class DetailViewController: UIViewController {
    //MARK: UI
    @IBOutlet weak var pictureCollectionView: UICollectionView!
    @IBOutlet weak var pageController: AdvancedPageControlView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var badgeImageView: UIImageView!
    @IBOutlet weak var nicknameButton: UIButton!
    @IBOutlet weak var scrapButton: UIButton!
    @IBOutlet weak var contentTextView: ActiveLabel!
    @IBOutlet weak var viewsLabel: UILabel!
    @IBOutlet weak var scrapsLabel: UILabel!
    @IBOutlet weak var profileTouchArea: UIButton!
    
    //MARK: Properties
    var detailId = String()
    private let disposeBag = DisposeBag()
    private let viewModel = DetailViewModel()
    private var loadData = BehaviorRelay<Void>(value: ())
    private var showDetailImages = [String]()
    private var profileIndex = PublishRelay<Void>()
    
    lazy var deletePostButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "삭제", style: .plain, target: self, action: nil)
        button.tintColor = MainColor.red
        return button
    }()
    private let animationView = AnimationView(name: "bookmark-animation").then {
        $0.contentMode = .scaleAspectFit
        $0.isHidden = true
    }
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageController.drawer = ExtendedDotDrawer(numberOfPages: 0, space: 5.0, indicatorColor: MainColor.primaryGreen, dotsColor: .white, isBordered: false, borderWidth: 0.0, indicatorBorderColor: .clear, indicatorBorderWidth: 0.0)
        
        contentTextView.numberOfLines = 0
        contentTextView.enabledTypes = [.hashtag]
        contentTextView.font = UIFont(name: "Noto Sans KR", size: 16)
        
        pictureCollectionView.addSubview(animationView)
        bindViewModel()
        
        scrapButton.rx.tap.subscribe(onNext: { _ in
            self.doubleTapped()
        }).disposed(by: disposeBag)
        setupConstraint()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        title = "게시글"
        loadData.accept(())
        navigationBackCustom()
    }
    
    //MARK: Bind
    private func bindViewModel() {
        let input = DetailViewModel.Input(getDetail: loadData.asSignal(onErrorJustReturn: ()),
                                          detailPostId: detailId, postScrap: scrapButton.rx.tap.asDriver(),
                                          deletePost: deletePostButton.rx.tap.asDriver(),
                                          getOtherProfile: profileIndex.asSignal())
        let output = viewModel.transform(input)
        
        output.getDetail.asObservable().bind {[unowned self] data in
            guard let data = data else { return }
            badgeImageView.image = UIImage(named: data.user.badgeCategory + "\(data.user.badgeLevel)")
            showDetailImages = data.images
            titleLabel.text = data.title
            nicknameButton.setTitle(data.user.nickname, for: .normal)
            scrapButton.isSelected = data.isScrap
            contentTextView.text = data.content
            viewsLabel.text = String(data.views)
            scrapsLabel.text = String(data.scraps)
            if data.isMine { navigationItem.rightBarButtonItem = deletePostButton }
            pageController.numberOfPages = data.images.count
            pictureCollectionView.reloadData()
        }.disposed(by: disposeBag)
        
        output.profileResult.asObservable()
            .subscribe(onNext: {[unowned self] profile in
            guard let vc = storyboard?.instantiateViewController(identifier: "profile") as? ProfileViewController else { return }
            vc.otherProfile.accept(profile)
            navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposeBag)
        
        output.result.emit(onCompleted : { self.navigationController?.popViewController(animated: true) }).disposed(by: disposeBag)
        
        output.scrapResult.asObservable().bind(to: loadData).disposed(by: disposeBag)
        profileTouchArea.rx.tap.bind(to: profileIndex).disposed(by: disposeBag)
    }
    
    private func setupConstraint() {
        animationView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(128)
            make.height.equalTo(128)
        }
    }
    
    private func doubleTapped() {
        animationView.isHidden = false
        animationView.play()
        animationView.play { _ in self.animationView.isHidden = true }
    }
}

final class DetailCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var detailImageView: UIImageView!
}

extension DetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return showDetailImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "scrollCell", for: indexPath) as! DetailCollectionViewCell
        
        cell.detailImageView.kf.setImage(with: URL(string: "https://shareup-bucket.s3.ap-northeast-2.amazonaws.com/" + showDetailImages[indexPath.row]))
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSet = scrollView.contentOffset.x
        let width = scrollView.frame.width
        
        pageController.setPageOffset(offSet / width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "imageDetail") as! DetailImageViewController
        vc.modalPresentationStyle = .fullScreen
        vc.sendImage = showDetailImages[indexPath.row]
        present(vc, animated: true, completion: nil)
    }
}

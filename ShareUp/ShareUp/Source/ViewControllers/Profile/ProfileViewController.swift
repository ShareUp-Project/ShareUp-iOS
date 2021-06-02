//
//  RecentlySearchViewController.swift
//  ShareUp
//
//  Created by 이가영 on 2021/04/30.
//

import UIKit
import RxSwift
import RxCocoa

final class ProfileViewController: UIViewController {
    //MARK: UI
    @IBOutlet weak var badgeImageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var myPostsTableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var infoView: UIView!
    
    //MARK: Properties
    private let disposeBag = DisposeBag()
    private let viewModel = ProfileViewModel()
    private let loadProfile = BehaviorRelay<Void>(value: ())
    var otherProfile = BehaviorRelay<String>(value: "")
    private let selectScrap = PublishRelay<Int>()

    lazy var settingButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "설정", style: .plain, target: self, action: nil)
        button.tintColor = MainColor.primaryGreen
        return button
    }()
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        setupTableView()
        managerTrait()
        addBottomShadow()

        if !otherProfile.value.isEmpty {
            navigationBackCustom()
        }
    }
    
    func addBottomShadow() {
        infoView.layer.masksToBounds = false
        infoView.layer.shadowRadius = 4
        infoView.layer.shadowOpacity = 1
        infoView.layer.shadowColor = MainColor.shadowGray.cgColor
        infoView.layer.shadowOpacity = 0.2
        infoView.layer.shadowOffset = CGSize(width: 0 , height: 2)
        infoView.layer.shadowPath = UIBezierPath(rect: CGRect(x: 0,
                                                              y: infoView.bounds.maxY - infoView.layer.shadowRadius,
                                                              width: infoView.bounds.width,
                                                              height: infoView.layer.shadowRadius)).cgPath
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        myPostsTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        myPostsTableView.reloadData()
        myPostsTableView.separatorInset = .zero

        loadProfile.accept(())
        tabBarController?.navigationItem.rightBarButtonItem = settingButton
        tabBarController?.navigationItem.leftBarButtonItems = []
        tabBarController?.navigationController?.navigationBar.topItem?.title = "프로필"
        title = "프로필"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        myPostsTableView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    //MARK: Bind
    private func bindViewModel() {
        let input = ProfileViewModel.Input(otherProfileId: otherProfile.asDriver(onErrorJustReturn: ""),
                                           loadProfile: loadProfile.asSignal(onErrorJustReturn: ()),
                                           loadMoreProfile: myPostsTableView.reachedBottom.asSignal(onErrorJustReturn: ()),
                                           loadDetail: myPostsTableView.rx.itemSelected.asSignal(),
                                           postScrap: selectScrap.asSignal())
        let output = viewModel.transform(input)
        
        output.myNickname.asObservable().bind {[unowned self] data in
            if data?.badgeCategory == "first" {
                badgeImageView.image = UIImage(named: data!.badgeCategory)
                nicknameLabel.text = data?.nickname
            }else {
                badgeImageView.image = UIImage(named: data!.badgeCategory + "\(data!.badgeLevel)")
                nicknameLabel.text = data?.nickname
            }
        }.disposed(by: disposeBag)
        
        output.myPosts.asObservable().bind(to: myPostsTableView.rx.items(cellIdentifier: "mainCell", cellType: PostTableViewCell.self)) { row, data, cell in
            cell.configCell(data)
            cell.scrapButton.rx.tap.subscribe(onNext: {[unowned self] _ in
                cell.doubleTapped()
                selectScrap.accept(row)
            }).disposed(by: cell.disposeBag)
        }.disposed(by: disposeBag)
        
        output.detailIndexPath.asObservable().subscribe(onNext: { [unowned self] detail in
            guard let vc = storyboard?.instantiateViewController(identifier: "detail") as? DetailViewController else { return }
            vc.detailId = detail
            navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposeBag)
    
        output.scrapResult.asObservable().subscribe(onNext: {[unowned self] _ in
            loadProfile.accept(())
            myPostsTableView.reloadData()
        }).disposed(by: disposeBag)
    }
    
    //MARK: Rx Action
    private func managerTrait() {
        settingButton.rx.tap.subscribe(onNext: {[unowned self] _ in
            self.pushViewController("setting")
        }).disposed(by: disposeBag)
        
        myPostsTableView.rx.didScroll.subscribe(onNext: {[unowned self] _ in
            if myPostsTableView.panGestureRecognizer.translation(in: myPostsTableView).y < 0 {
                navigationController?.setNavigationBarHidden(true, animated: true)
            } else {
                navigationController?.setNavigationBarHidden(false, animated: true)
            }
        }).disposed(by: disposeBag)
    }
    
    private func setupTableView() {
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        myPostsTableView.register(nib, forCellReuseIdentifier: "mainCell")
        myPostsTableView.rowHeight = UITableView.automaticDimension
        myPostsTableView.estimatedRowHeight = 350
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            if let newValue = change?[.newKey] {
                let newSize = newValue as! CGSize
                self.tableViewHeight.constant = newSize.height
            }
        }
    }
}

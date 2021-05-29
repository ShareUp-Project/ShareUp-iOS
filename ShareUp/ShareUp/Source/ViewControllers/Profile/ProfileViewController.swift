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
    
    //MARK: Properties
    private let disposeBag = DisposeBag()
    private let viewModel = ProfileViewModel()
    private let loadProfile = BehaviorRelay<Void>(value: ())
    var otherProfile = BehaviorRelay<String>(value: "")
    
    lazy var settingButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "설정", style: .done, target: self, action: nil)
        button.tintColor = MainColor.primaryGreen
        return button
    }()
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        setupTableView()
        managerTrait()
        
        if !otherProfile.value.isEmpty {
            navigationBackCustom()
        }
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
                                           loadDetail: myPostsTableView.rx.itemSelected.asSignal())
        let output = viewModel.transform(input)
        
        output.myNickname.asObservable().bind {[unowned self] data in
            badgeImageView.image = UIImage(named: data!.badgeCategory + "\(data!.badgeLevel)")
            nicknameLabel.text = data?.nickname}.disposed(by: disposeBag)
        
        output.myPosts.asObservable().bind(to: myPostsTableView.rx.items(cellIdentifier: "mainCell", cellType: PostTableViewCell.self)) { row, data, cell in
            cell.configCell(data)
        }.disposed(by: disposeBag)
        
        output.detailIndexPath.asObservable().subscribe(onNext: { [unowned self] detail in
            guard let vc = storyboard?.instantiateViewController(identifier: "detail") as? DetailViewController else { return }
            vc.detailId = detail
            navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposeBag)
    }
    
    //MARK: Rx Action
    private func managerTrait() {
        settingButton.rx.tap.subscribe(onNext: { _ in
            self.pushViewController("setting")
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


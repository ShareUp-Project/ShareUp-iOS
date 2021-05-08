//
//  RecentlySearchViewController.swift
//  ShareUp
//
//  Created by 이가영 on 2021/04/30.
//

import UIKit
import RxSwift
import RxCocoa

class ProfileViewController: UIViewController {

    @IBOutlet weak var badgeImageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var myPostsTableView: UITableView!
    
    private let disposeBag = DisposeBag()
    private let viewModel = ProfileViewModel()
    private let loadProfile = BehaviorRelay<Void>(value: ())
    
    lazy var settingButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "설정", style: .done, target: self, action: nil)
        button.tintColor = MainColor.primaryGreen
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
        setupTableView()
        managerTrait()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadProfile.accept(())
        tabBarController?.navigationItem.rightBarButtonItem = settingButton
    }
    
    private func bindViewModel() {
        let input = ProfileViewModel.Input(loadProfile: loadProfile.asSignal(onErrorJustReturn: ()),
                                           loadMoreProfile: myPostsTableView.reachedBottom.asSignal(onErrorJustReturn: ()))
        let output = viewModel.transform(input)
        
        output.myNickname.asObservable().bind {[unowned self] nickname in nicknameLabel.text = nickname}.disposed(by: disposeBag)
        
        output.myPosts.asObservable().bind(to: myPostsTableView.rx.items(cellIdentifier: "mainCell", cellType: PostTableViewCell.self)) { row, data, cell in
            cell.configCell(data)
        }.disposed(by: disposeBag)
    }
    
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
}

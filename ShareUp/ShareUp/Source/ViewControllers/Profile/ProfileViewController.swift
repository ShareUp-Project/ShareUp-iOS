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

    @IBOutlet weak var badgeImageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var myPostsTableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
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
        
        myPostsTableView.delegate = nil
        myPostsTableView.dataSource = nil
        
        bindViewModel()
        setupTableView()
        managerTrait()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        myPostsTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        myPostsTableView.reloadData()
        
        loadProfile.accept(())
        tabBarController?.navigationItem.rightBarButtonItem = settingButton
        tabBarController?.navigationItem.leftBarButtonItems = []
        myPostsTableView.separatorInset = .zero
        tabBarController?.navigationController?.navigationBar.topItem?.title = "프로필"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        myPostsTableView.removeObserver(self, forKeyPath: "contentSize")
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

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            if let newValue = change?[.newKey] {
                let newSize = newValue as! CGSize
                self.tableViewHeight.constant = newSize.height
            }
        }
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

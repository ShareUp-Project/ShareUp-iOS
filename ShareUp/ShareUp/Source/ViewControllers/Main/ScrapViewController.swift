//
//  ScrapViewController.swift
//  ShareUp
//
//  Created by 이가영 on 2021/04/09.
//

import UIKit
import RxSwift
import RxCocoa

final class ScrapViewController: UIViewController {
    //MARK: UI
    @IBOutlet weak var scrapTableView: UITableView!
    
    //MARK: Properties
    private let viewModel = ScarpViewModel()
    private let disposeBag = DisposeBag()
    private let getData = BehaviorRelay<Void>(value: ())
    private let selectScrap = PublishRelay<Int>()
    private let selectProfile = PublishRelay<Int>()

    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
        setTableView()
        scrapTableView.tableFooterView = UIView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        getData.accept(())
        scrapTableView.reloadData()
        navigationController?.navigationBar.topItem?.title = "보관함"
        tabBarController?.navigationItem.rightBarButtonItems = []
        tabBarController?.navigationItem.leftBarButtonItems = []
        scrapTableView.separatorInset = .zero
    }

    //MARK: Bind
    private func bindViewModel() {
        let input = ScarpViewModel.Input(getScarpPosts: getData.asSignal(onErrorJustReturn: ()),
                                         loadDetail: scrapTableView.rx.itemSelected.asSignal(),
                                         deleteScarp: selectScrap.asSignal(),
                                         getMoreScrapPosts: scrapTableView.reachedBottom.asSignal(onErrorJustReturn: ()),
                                         getOtherProfile: selectProfile.asSignal())
        let output = viewModel.transform(input)
        
        output.getScarpPosts.asObservable().bind(to: scrapTableView.rx.items(cellIdentifier: "mainCell", cellType: PostTableViewCell.self)) { row, data, cell in
            cell.scrapConfigCell(data)
            cell.scrapButton.rx.tap.subscribe(onNext: {[unowned self] _ in selectScrap.accept(row) }).disposed(by: cell.disposeBag)
            cell.profileTouchArea.rx.tap.subscribe(onNext: {[unowned self] _ in selectProfile.accept(row) }).disposed(by: cell.disposeBag)
        }.disposed(by: disposeBag)
        
        output.detailIndexPath.asObservable().subscribe(onNext: { [unowned self] detail in
            guard let vc = storyboard?.instantiateViewController(identifier: "detail") as? DetailViewController else { return }
            vc.detailId = detail
            navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposeBag)
        
        output.profileIndexPath.asObservable().subscribe(onNext: {[unowned self] profile in
            guard let vc = storyboard?.instantiateViewController(identifier: "profile") as? ProfileViewController else { return }
            vc.otherProfile.accept(profile)
            navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposeBag)
        
        output.scrapResult.asObservable().subscribe(onNext: {[unowned self] _ in
            getData.accept(())
            scrapTableView.reloadData()
        }).disposed(by: disposeBag)
    }
    
    private func setTableView() {
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        scrapTableView.register(nib, forCellReuseIdentifier: "mainCell")
        scrapTableView.rowHeight = UITableView.automaticDimension
        scrapTableView.estimatedRowHeight = 350
    }
    
}


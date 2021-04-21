//
//  MainViewController.swift
//  ShareUp
//
//  Created by 이가영 on 2021/04/07.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher
import Lottie

class MainViewController: UIViewController {

    @IBOutlet weak var mainTableView: UITableView!
    
    private let viewModel = MainViewModel()
    private let disposeBag = DisposeBag()
    private let getData = PublishRelay<Void>()
    private let selectScrap = PublishRelay<Int>()
    private let animationPost = PublishRelay<Int>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
        setTableView()
        navigationController?.navigationBar.topItem?.title = "ShareUp"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        getData.accept(())
        mainTableView.reloadData()
        
        navigationController?.navigationBar.topItem?.title = "ShareUp"
        tabBarController?.navigationItem.rightBarButtonItems = []
        mainTableView.separatorInset = .zero
    }

    private func bindViewModel() {
        let input = MainViewModel.Input(getPosts: getData.asSignal(onErrorJustReturn: ()),
                                        loadDetail: mainTableView.rx.itemSelected.asSignal(),
                                        postScrap: selectScrap.asSignal(),
                                        animationPost: animationPost.asSignal())
        let output = viewModel.transform(input)
        
        output.getPosts.asObservable().bind(to: mainTableView.rx.items(cellIdentifier: "mainCell", cellType: PostTableViewCell.self)) { row, data, cell in
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
            getData.accept(())
            mainTableView.reloadData()
        }).disposed(by: disposeBag)
    }

    private func setTableView() {
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        mainTableView.register(nib, forCellReuseIdentifier: "mainCell")
        mainTableView.rowHeight = UITableView.automaticDimension
        mainTableView.estimatedRowHeight = 350
        
    }
}

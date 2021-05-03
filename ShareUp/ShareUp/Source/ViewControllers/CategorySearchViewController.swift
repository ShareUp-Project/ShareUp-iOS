//
//  SerachViewController.swift
//  ShareUp
//
//  Created by 이가영 on 2021/04/27.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class CategorySearchViewController: UIViewController {

    @IBOutlet var categoryView: [UIView]!
    @IBOutlet var categoryBackgroundView: [UIView]!
    @IBOutlet var categoryTouchArea: [UIButton]!
    @IBOutlet weak var recentlySearchView: UIView!
    @IBOutlet weak var searchTableView: UITableView!
    
    private let viewModel = SearchViewModel()
    private let disposeBag = DisposeBag()
    private var selectCategory = PublishRelay<String>()
    private let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 320, height: 0))
    private let cancel = UIBarButtonItem(title: "취소", style: .plain, target: self, action: nil)
    

    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
        managerTrait()
        setupTableView()
        searchBar.rx.textDidBeginEditing.subscribe(onNext: { _ in
            self.recentlySearchView.isHidden = false
        }).disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.rightBarButtonItem = cancel
        searchBar.placeholder = "검색"
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchBar)
        
        navigationBackCustom()
    }
    
    private func bindViewModel() {
        let input = SearchViewModel.Input(searchTap: searchBar.rx.searchButtonClicked.asDriver(),
                                          loadDetail: searchTableView.rx.itemSelected.asDriver(),
                                          searchContent: searchBar.rx.text.asDriver(),
                                          searchCategory: selectCategory.asDriver(onErrorJustReturn: ""))
        let output = viewModel.transform(input)

        output.isRecentlyOn.drive(recentlySearchView.rx.isHidden).disposed(by: disposeBag)
        
        output.getCategoryPosts.asObservable().bind(to: searchTableView.rx.items(cellIdentifier: "mainCell", cellType: PostTableViewCell.self)) { row, data, cell in
            cell.configCell(data)
        }.disposed(by: disposeBag)
        
        output.getCategoryPosts.asObservable().subscribe(onNext: { _ in
            self.searchTableView.isHidden = false
        }).disposed(by: disposeBag)
        
        output.detailIndexPath.asObservable().subscribe(onNext: { [unowned self] detail in
            guard let vc = storyboard?.instantiateViewController(identifier: "detail") as? DetailViewController else { return }
            vc.detailId = detail
            navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposeBag)
    }

    private func managerTrait() {
        categoryTouchArea[0].rx.tap.subscribe(onNext: { _ in
            self.selectCategory.accept(ShareUpFilter.filterCategorySearch(1))
        }).disposed(by: disposeBag)
        
        categoryTouchArea[1].rx.tap.subscribe(onNext: { _ in
            self.selectCategory.accept(ShareUpFilter.filterCategorySearch(2))
        }).disposed(by: disposeBag)
        
        categoryTouchArea[2].rx.tap.subscribe(onNext: { _ in
            self.selectCategory.accept(ShareUpFilter.filterCategorySearch(3))
        }).disposed(by: disposeBag)
        
        categoryTouchArea[3].rx.tap.subscribe(onNext: { _ in
            self.selectCategory.accept(ShareUpFilter.filterCategorySearch(4))
        }).disposed(by: disposeBag)
        
        categoryTouchArea[4].rx.tap.subscribe(onNext: { _ in
            self.selectCategory.accept(ShareUpFilter.filterCategorySearch(5))
        }).disposed(by: disposeBag)
        
        categoryTouchArea[5].rx.tap.subscribe(onNext: { _ in
            self.selectCategory.accept(ShareUpFilter.filterCategorySearch(6))
        }).disposed(by: disposeBag)
        
        categoryTouchArea[6].rx.tap.subscribe(onNext: { _ in
            self.selectCategory.accept(ShareUpFilter.filterCategorySearch(7))
        }).disposed(by: disposeBag)
        
        categoryTouchArea[7].rx.tap.subscribe(onNext: { _ in
            self.selectCategory.accept(ShareUpFilter.filterCategorySearch(8))
        }).disposed(by: disposeBag)
    }
    
    private func setupTableView() {
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        searchTableView.register(nib, forCellReuseIdentifier: "mainCell")
        searchTableView.rowHeight = UITableView.automaticDimension
        searchTableView.estimatedRowHeight = 350
    }
}

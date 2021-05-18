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

final class CategorySearchViewController: UIViewController {

    @IBOutlet var categoryView: [UIView]!
    @IBOutlet var categoryBackgroundView: [UIView]!
    @IBOutlet var categoryTouchArea: [UIButton]!
    @IBOutlet weak var weeklyBestTableView: UITableView!
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var recentlySearchView: RecentlySearch!
    
    private let viewModel = SearchViewModel()
    private let disposeBag = DisposeBag()
    private var selectCategory = PublishRelay<String>()
    private let loadWeeklyPost = BehaviorRelay<Void>(value: ())
    private let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 280, height: 0)).then {
        $0.returnKeyType = .done
    }
    
    lazy var cancelButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        managerTrait()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        searchBar.placeholder = "검색"
        navigationItem.rightBarButtonItems = [cancelButton, UIBarButtonItem(customView: searchBar)]
        weeklyBestTableView.separatorStyle = .none
        navigationBackCustom()
    }
    
    private func bindViewModel() {
        let input = SearchViewModel.Input(searchTap: searchBar.rx.searchButtonClicked.asDriver(),
                                          loadDetail: searchTableView.rx.itemSelected.asDriver(),
                                          searchContent: searchBar.rx.text.asDriver(),
                                          searchCategory: selectCategory.asDriver(onErrorJustReturn: ""),
                                          loadWeeklyPost: loadWeeklyPost.asDriver(),
                                          loadPopularPostDetail: weeklyBestTableView.rx.itemSelected.asDriver())
        let output = viewModel.transform(input)

        output.isRecentlyOn.drive(recentlySearchView.rx.isHidden).disposed(by: disposeBag)
        
        output.getCategoryPosts.asObservable().bind(to: searchTableView.rx.items(cellIdentifier: "mainCell", cellType: PostTableViewCell.self)) { row, data, cell in
            cell.configCell(data)
        }.disposed(by: disposeBag)
        
        output.getWeeklyPosts.asObservable().bind(to: weeklyBestTableView.rx.items(cellIdentifier: "weeklyCell", cellType: WeeklyTableViewCell.self)) { row, data, cell in
            cell.bestPostLabel.text = data.title
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
        
        searchBar.rx.textDidBeginEditing.asObservable().subscribe(onNext: { _ in
            if self.searchBar.text!.isEmpty {
                self.recentlySearchView.isHidden = false
            }
        }).disposed(by: disposeBag)

        searchBar.rx.text.subscribe(onNext: {[unowned self] text in
            recentlySearchView.recentlyTag.isHidden = !text!.isEmpty ? true : false
        }).disposed(by: disposeBag)
        
        cancelButton.rx.tap.subscribe(onNext: {[unowned self] _ in
            searchTableView.isHidden = true
            searchBar.endEditing(true)
            recentlySearchView.isHidden = true
            searchBar.text = ""
        }).disposed(by: disposeBag)
    }
    
    private func setupTableView() {
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        searchTableView.register(nib, forCellReuseIdentifier: "mainCell")
        searchTableView.rowHeight = UITableView.automaticDimension
        weeklyBestTableView.rowHeight = 32
        searchTableView.estimatedRowHeight = 350
    }

}

class WeeklyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bestPostLabel: UILabel!
    
}

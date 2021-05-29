//
//  EditorViewController.swift
//  ShareUp
//
//  Created by 이가영 on 2021/05/03.
//

import UIKit
import RxSwift
import RxCocoa

final class EditorViewController: UIViewController {
    //MARK: UI
    @IBOutlet weak var editorTableView: UITableView!
    
    //MARK: Properties
    private let disposeBag = DisposeBag()
    private let viewModel = EditorViewModel()
    private let loadData = BehaviorRelay<Void>(value: ())
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        editorTableView.separatorInset = .zero
        navigationController?.navigationBar.topItem?.title = "에디터의 글"
        tabBarController?.navigationItem.rightBarButtonItems = []
        tabBarController?.navigationItem.leftBarButtonItems = []
    }
    
    //MARK: Bind
    private func bindViewModel() {
        let input = EditorViewModel.Input(loadData: loadData.asDriver(),
                                          loadMoreData: editorTableView.reachedBottom.asDriver(onErrorJustReturn: ()),
                                          loadDetail: editorTableView.rx.itemSelected.asDriver())
        let output = viewModel.transform(input)
        
        output.getEditorPosts.asObservable().bind(to: editorTableView.rx.items(cellIdentifier: "editorCell", cellType: EditorTableViewCell.self)) { row, data, cell in
            cell.configCell(data)
        }.disposed(by: disposeBag)
        
        output.getDetailValue.asObservable().subscribe(onNext: {[unowned self] data in
            let vc = storyboard?.instantiateViewController(identifier: "editorDetail") as! EditorDetailViewController
            vc.editorDetailData = data
            navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposeBag)
    }

    private func setupTableView() {
        editorTableView.rowHeight = 144
    }
}


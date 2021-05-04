//
//  EditorViewController.swift
//  ShareUp
//
//  Created by 이가영 on 2021/05/03.
//

import UIKit
import RxSwift
import RxCocoa

class EditorViewController: UIViewController {

    @IBOutlet weak var editorTableView: UITableView!
    
    private let disposeBag = DisposeBag()
    private let viewModel = EditorViewModel()
    private let loadData = BehaviorRelay<Void>(value: ())
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
    }
    
    private func bindViewModel() {
        let input = EditorViewModel.Input(loadData: loadData.asDriver(),
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

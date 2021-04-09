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

class MainViewController: UIViewController {

    @IBOutlet weak var mainTableView: UITableView!
    
    private let viewModel = MainViewModel()
    private let disposeBag = DisposeBag()
    private let getData = BehaviorRelay<Void>(value: ())
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    private func bindViewModel() {
        let input = MainViewModel.Input(getPosts: Completable.empty())
        let output = viewModel.transform(input)
        
        output.getPosts.asObservable().bind(to: mainTableView.rx.items(cellIdentifier: "mainCell", cellType: PostTableViewCell.self)) { row, data, cell in
            cell.configCell(data)
        }.disposed(by: disposeBag)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

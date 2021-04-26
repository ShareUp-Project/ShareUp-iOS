//
//  PostViewController.swift
//  ShareUp
//
//  Created by 이가영 on 2021/04/13.
//

import UIKit
import BSImagePicker
import RxSwift
import Photos
import RxCocoa

class PostViewController: UIViewController {
    
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var cameraBoxView: UIView!
    @IBOutlet weak var numOfPictureLabel: UILabel!
    @IBOutlet weak var pickerCollectionView: UICollectionView!
    @IBOutlet var categoryButton: [UIButton]!
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    private var categoryTraking = BehaviorRelay<String>(value: "")
    private let viewModel = PostViewModel()
    private let disposeBag = DisposeBag()
    private let multipleImages = PublishRelay<[Data]>()
    private var selectMultiImage = [PHAsset]() {
        willSet {
            if selectMultiImage.count != 0 { numOfPictureLabel.textColor = MainColor.primaryGreen }
        }
    }
    
    lazy var postButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "완료", style: .plain, target: self, action: nil)
        button.tintColor = MainColor.primaryGreen
        button.isEnabled = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        managerTrait()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.topItem?.title = "글쓰기"
        tabBarController?.navigationItem.rightBarButtonItem = postButton
        tabBarController?.navigationItem.leftBarButtonItems = []
    }
    
    private func bindViewModel() {
        let input = PostViewModel.Input(postTap: postButton.rx.tap.asDriver(),
                                        isImage: multipleImages.asDriver(onErrorJustReturn: []),
                                        isTitle: titleTextView.rx.text.orEmpty.asDriver(),
                                        isContent: contentTextView.rx.text.orEmpty.asDriver(),
                                        isCategory: categoryTraking.asDriver(onErrorJustReturn: ""))
        let output = viewModel.transform(input)
        
        output.result.emit(onCompleted: {[unowned self] in
            loadingView.isHidden = true
            pushViewController("main")
        }).disposed(by: disposeBag)
        
        output.isEnable.drive(postButton.rx.isEnabled).disposed(by: disposeBag)
    }
    
    private func managerTrait() {
        cameraButton.rx.tap.subscribe(onNext: {[unowned self] _ in
            let imagePicker = ImagePickerController()
            imagePicker.settings.selection.max = 8
            imagePicker.settings.theme.selectionStyle = .numbered
            imagePicker.settings.fetch.assets.supportedMediaTypes = [.image]
            imagePicker.settings.selection.unselectOnReachingMax = true
            selectMultiImage.removeAll()
            presentImagePicker(imagePicker, select: { (asset) in
            }, deselect: { (asset) in
            }, cancel: { (assets) in
            }, finish: { (assets) in
                for i in 0..<assets.count {
                    self.selectMultiImage.append(assets[i])
                }
                pickerCollectionView.reloadData()
                multipleImages.accept(getData(selectMultiImage))
                numOfPictureLabel.text = String(selectMultiImage.count)
            }, completion: {
                pickerCollectionView.reloadData()
            })
        }).disposed(by: disposeBag)
        
        cameraBoxView.layer.borderColor = MainColor.gray03.cgColor
        
        postButton.rx.tap.subscribe(onNext: { _ in
            self.loadingView.isHidden = false
            self.loadingView.startAnimating()
        }).disposed(by: disposeBag)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show" {
            let viewController : CategoryViewController = segue.destination as! CategoryViewController
            viewController.delegate = self
        }
    }
}

extension PostViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectMultiImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pickerCell", for: indexPath) as! PickerCollectionViewCell
        
        cell.pickerImageView.image = selectMultiImage[indexPath.row].getUIImage()
        cell.removeButton.rx.tap.subscribe(onNext: {[unowned self] _ in
            selectMultiImage.remove(at: indexPath.row)
            pickerCollectionView.reloadData()
            numOfPictureLabel.text = String(selectMultiImage.count)
        }).disposed(by: cell.disposeBag)
        
        return cell
    }
}

extension PostViewController: DismissSendData {
    func dismissData(_ data: String) {
        categoryButton[0].setTitle(data, for: .normal)
        categoryTraking.accept(data)
    }
}

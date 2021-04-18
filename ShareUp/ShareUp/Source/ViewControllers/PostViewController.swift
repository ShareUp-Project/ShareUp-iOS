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

    private var selectAsset = [PHAsset]()
    private var convertImageData = [Data]()
    private var categoryTraking = BehaviorRelay<String>(value: "")
    private let viewModel = PostViewModel()
    private let disposeBag = DisposeBag()
    private let selectImage = PublishRelay<[Data]>()
    
    lazy var rightButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "완료", style: .plain, target: self, action: nil)
        button.tintColor = MainColor.primaryGreen
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        managerTrait()
        bindViewModel()
        
        contentTextView.linkTextAttributes = [NSAttributedString.Key.foregroundColor: MainColor.primaryGreen]

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.topItem?.title = "글쓰기"
        tabBarController?.navigationItem.rightBarButtonItem = rightButton
    }
    
    private func bindViewModel() {
        let input = PostViewModel.Input(postTap: rightButton.rx.tap.asDriver(),
                                        isImage: selectImage.asDriver(onErrorJustReturn: []),
                                        isTitle: titleTextView.rx.text.orEmpty.asDriver(),
                                        isContent: contentTextView.rx.text.orEmpty.asDriver(),
                                        isCategory: categoryTraking.asDriver(onErrorJustReturn: ""))
        let output = viewModel.transform(input)
        
        output.result.emit(onCompleted: {[unowned self] in
            pushViewController("main")
        }).disposed(by: disposeBag)
        
        output.isEnable.drive(rightButton.rx.isEnabled).disposed(by: disposeBag)
        output.isEnable.drive(onNext: {[unowned self] send in
            print(send)
        }).disposed(by: disposeBag)
    }
    
    private func managerTrait() {
        cameraButton.rx.tap.subscribe(onNext: {[unowned self] _ in
            let imagePicker = ImagePickerController()
            imagePicker.settings.selection.max = 8
            imagePicker.settings.theme.selectionStyle = .numbered
            imagePicker.settings.fetch.assets.supportedMediaTypes = [.image]
            imagePicker.settings.selection.unselectOnReachingMax = true
            
            presentImagePicker(imagePicker, select: { (asset) in
            }, deselect: { (asset) in
            }, cancel: { (assets) in
            }, finish: { (assets) in
                for i in 0..<assets.count
                {
                    self.selectAsset.append(assets[i])
                }
                pickerCollectionView.reloadData()
                selectImage.accept(getData(selectAsset))
                numOfPictureLabel.text = String(selectAsset.count)
            }, completion: {
                pickerCollectionView.reloadData()
            })
        }).disposed(by: disposeBag)
        
        contentTextView.rx.text.subscribe(onNext: { [unowned self] text in
            contentTextView.resolveHashTags()
        }).disposed(by: disposeBag)
        
        titleTextView.text = "이곳을 눌러 제목을 입력하세요."
        titleTextView.textColor = UIColor.lightGray
        contentTextView.text = "쉐어업에 공유할 업사이클 이야기를 작성해주세요. 태그는 본문에 원하는 #태그를 입력하면 자동으로 태그됩니다."
        contentTextView.textColor = UIColor.lightGray
        cameraBoxView.layer.borderColor = MainColor.gray03.cgColor
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show" {
            let viewController : CategoryViewController = segue.destination as! CategoryViewController
            viewController.delegate = self
        }
    }
}

extension PostViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty && textView == titleTextView{
            textView.text = "이곳을 눌러 제목을 입력하세요."
            textView.textColor = UIColor.lightGray
        }else if textView.text.isEmpty && textView == contentTextView {
            textView.text = "쉐어업에 공유할 업사이클 이야기를 작성해주세요. 태그는 본문에 원하는 #태그를 입력하면 자동으로 태그됩니다."
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        contentTextView.resolveHashTags()
    }
    
}

extension PostViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectAsset.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pickerCell", for: indexPath) as! PickerCollectionViewCell
        
        cell.pickerImageView.image = selectAsset[indexPath.row].getUIImage()
        cell.removeButton.rx.tap.subscribe(onNext: {[unowned self] _ in
            selectAsset.remove(at: indexPath.row)
            pickerCollectionView.reloadData()
            numOfPictureLabel.text = String(selectAsset.count)
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

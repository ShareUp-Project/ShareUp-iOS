//
//  PostViewController.swift
//  ShareUp
//
//  Created by 이가영 on 2021/04/13.
//

import UIKit

class PostViewController: UIViewController {

    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var numOfPictureLabel: UILabel!
    @IBOutlet weak var pickerCollectionView: UICollectionView!
    @IBOutlet var categoryButton: [UIButton]!
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var contentTextView: UITextView!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTextView.delegate = self
        
        titleTextView.text = "이곳을 눌러 제목을 입력하세요."
        titleTextView.textColor = UIColor.lightGray
        contentTextView.delegate = self
        
        contentTextView.text = "쉐어업에 공유할 업사이클 이야기를 작성해주세요. 태그는 본문에 원하는 #태그를 입력하면 자동으로 태그됩니다."
        contentTextView.textColor = UIColor.lightGray
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
}

extension PostViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectAsset.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pickerCell", for: indexPath) as! PickerCollectionViewCell
        
        cell.pickerImageView.image = getUIImage(asset: selectAsset[indexPath.row])
        cell.removeButton.rx.tap.subscribe(onNext: {[unowned self] _ in
            print(indexPath.row)
            selectAsset.remove(at: indexPath.row)
            pickerCollectionView.reloadData()
        }).disposed(by: cell.disposeBag)
        
        return cell
    }
}

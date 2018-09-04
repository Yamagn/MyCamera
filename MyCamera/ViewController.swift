//
//  ViewController.swift
//  MyCamera
//
//  Created by ymgn on 2018/09/02.
//  Copyright © 2018年 ymgn. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var pictureImage: UIImageView!
    @IBAction func cameraButtonAction(_ sender: Any) {
        // カメラかライブラリーどちらから画像を取得するか選択
        let alertController = UIAlertController(title: "確認", message: "選択してください", preferredStyle: .actionSheet)
        
        // カメラが使用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            // カメラを起動するための選択肢を定義
            let cameraAction = UIAlertAction(title: "カメラ", style: .default, handler: {(action:UIAlertAction) in
                // カメラを起動
                let imagePickerController : UIImagePickerController = UIImagePickerController()
                imagePickerController.sourceType = .camera
                imagePickerController.delegate = self
                self.present(imagePickerController, animated: true, completion: nil)
            })
            alertController.addAction(cameraAction)
        }
        
        // フォトライブラリが使用可能かチェック
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            // フォトライブラリを起動するための選択肢を定義
            let photoLibraryAction = UIAlertAction(title: "フォトライブラリ", style: .default, handler: { (action:UIAlertAction) in
                // フォトライブラリを起動
                let imagePickerController : UIImagePickerController = UIImagePickerController()
                imagePickerController.sourceType = .photoLibrary
                imagePickerController.delegate = self
                self.present(imagePickerController, animated: true, completion: nil)
            })
            alertController.addAction(photoLibraryAction)
        }
        
        // キャンセルの選択肢を定義
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        // iPadで落ちてしまう対策
        alertController.popoverPresentationController?.sourceView = view
        
        // 選択肢を画面に表示
        present(alertController, animated: true, completion: nil)
    }
    @IBAction func SNSButtonAction(_ sender: Any) {
        // 表示画像をアンラップしてシェア画像として取り出し
        if let shareImage = pictureImage.image {
            
            // UIActivityViewcontrollerに渡す配列を作成
            let shareItems = [shareImage]
            
            // UIActivityViewControllerにシェア画像を渡す
            let controller = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
            
            // iPadで落ちてしまう対策
            controller.popoverPresentationController?.sourceView = view
            
            // UIActivityViewControllerを表示
            present(controller, animated: true, completion: nil)
        }
    }
    
    // 撮影が終わった時に呼ばれるdelegateメソッド
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // 撮影した写真を、配置したpictureImageに渡す
        captureImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        // モーダルビューを閉じる
        dismiss(animated: true, completion: {
        
            self.performSegue(withIdentifier: "showEffectView", sender: nil)
        })
    }
    
    // 次の画面に遷移するときに渡す画像を格納する場所
    var captureImage : UIImage?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 次の画面のインスタンスを格納
        if let nextViewController = segue.destination as? EffectViewController {
            // 次の画面のインスタンスに取得した画像を渡す
            nextViewController.originImage = captureImage
        }
    }
}


//
//  PreviewViewController.swift
//  Face1.1
//
//  Created by 刘友 on 2018/1/3.
//  Copyright © 2018年 刘友. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var photo: UIImageView!
    // 用于缩放
    @IBOutlet weak var scrollView: UIScrollView!
    
    var image:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photo.image = image
        // Do any additional setup after loading the view.
        // 缩放倍数
        self.scrollView.maximumZoomScale = 5.0
        self.scrollView.minimumZoomScale = 1.0
    }
    @IBAction func cancelButton_TouchUpInside(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func saveButton_TouchUpInside(_ sender: Any) {
        guard let imageToSave = image else {
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(imageToSave, nil, nil, nil)
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //UIScrollView协议的方法
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.photo
    }

    @IBAction func FaceButton(_ sender: UIButton) {
        UIAlterViewTip()
    }
    @IBAction func EditButton(_ sender: UIButton) {
        UIAlterViewTip()
    }
    @IBAction func AddTextButton(_ sender: UIButton) {
        UIAlterViewTip()
    }
    //尚未完成功能AlViewView提示
    func UIAlterViewTip() {
        let alertController = UIAlertController(title: "系统提示",
                                                message: "功能尚未完成，敬请期待~", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "好的，很是期待呢", style: .cancel, handler: nil)
        //        let okAction = UIAlertAction(title: "好的", style: .default, handler: {
        //            action in
        //            print("点击了确定")
        //        })
        alertController.addAction(cancelAction)
        //alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

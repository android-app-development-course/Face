//
//  ViewController.swift
//  Face1.1
//
//  Created by 刘友 on 2018/1/3.
//  Copyright © 2018年 刘友. All rights reserved.
//

import UIKit
import AVFoundation
class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    
    @IBOutlet weak var cameraButton: UIButton!
    
    @IBAction func ImageLibraryButton(_ sender: UIButton) {
        
        let image = UIImagePickerController()
        image.delegate = self
        
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        image.allowsEditing = false
        
        self.present(image, animated: true) {
            // After it is complete
        }
    }
    
    @IBAction func FilterLibraryButton(_ sender: UIButton) {
        nextPage()
        //self.navigationController?.pushViewController(FilterLibraryViewController(), animated: true)
        print("选中FilterLibraryButton")
    }
    
    
    var image: UIImage?
    
    fileprivate var visage : Visage?
    fileprivate let notificationCenter : NotificationCenter = NotificationCenter.default
    //滤镜的位置
    var followBounds: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    //滤镜
    let fishFrame: UIImageView = UIImageView(image: UIImage(named: "newFish")!)
    let santaFrame :UIImageView = UIImageView(image: UIImage(named: "satan")!)
    let santaBeardFrame:UIImageView = UIImageView(image: UIImage(named: "santab")!)
    let santaHatFrame:UIImageView = UIImageView(image: UIImage(named: "santaH"))
    // 滤镜的标号
    var i:Int = 3
    
    @IBOutlet weak var shotBtn: UIButton!
    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var photoBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.addSubview(fishFrame)
        
        visage = Visage(cameraPosition: Visage.CameraDevice.faceTimeCamera, optimizeFor: Visage.DetectorAccuracy.higherPerformance)
        visage?.myVC = self
        visage!.onlyFireNotificatonOnStatusChange = false
        visage!.beginFaceDetection()
        let cameraView = visage!.visageCameraView
        self.view.addSubview(cameraView)
        normalSortView()
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "visageFaceDetectedNotification"), object: nil, queue: OperationQueue.main, using: { notification in
            if let b = self.visage?.faceBounds {
                switch(self.i){
                case 0:
                    self.updateFish(newFaceBounds: b)
                case 1:
                    self.updateSanta(newFaceBounds: b)
                case 2:
                    self.updateSantaBeard(newFaceBounds: b)
                case 3:
                    self.updateSantaHat(newFaceBounds: b)
                default:
                    self.updateSanta(newFaceBounds: b)
                }
            }
        })
        
        //The same thing for the opposite, when no face is detected things are reset.
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "visageNoFaceDetectedNotification"), object: nil, queue: OperationQueue.main, using: { notification in
            let b:CGRect  = CGRect(x: 0, y: 0, width: 0, height: 0)
            switch(self.i){
            case 0:
                self.updateFish(newFaceBounds: b)
            case 1:
                self.updateSanta(newFaceBounds: b)
            case 2:
                self.updateSantaBeard(newFaceBounds: b)
            case 3:
                self.updateSantaHat(newFaceBounds: b)
            default:
                self.updateSanta(newFaceBounds: b)
            }
        })
        
        styleCaptureButton()
        nextPage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        normalSortView()
    }
    
    
    //push
//    func nextPage()
//    {
//        let nextVC = NextViewController()
//        //指定代理
//        nextVC.delegate = self
//        self.navigationController!.pushViewController(nextVC,animated:true)
//    }
    
    //push
    func nextPage() {
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "myNavi") as! UINavigationController
        let smlVC = nextVC.topViewController as! FilterLibraryViewController
        smlVC.delegate = self
        
        performSegue(withIdentifier: "toNavi", sender: nil)
    }
    

    // 接受传过来的值
//    func getValue(_ controller: FilterLibraryViewController, FilterId: Int) {
//        i = FilterId
//        print("Filter的值是\(i)")
//    }
    
    
    var filterView:UIView!
    func normalSortView(){
        switch(self.i){
        case 0:
            filterView = fishFrame
            self.view.addSubview(fishFrame)
            self.view.bringSubview(toFront: fishFrame)
            self.santaFrame.removeFromSuperview()
            self.santaHatFrame.removeFromSuperview()
            self.santaBeardFrame.removeFromSuperview()
        case 1:
            filterView = santaFrame
            self.view.addSubview(santaFrame)
            self.view.bringSubview(toFront: santaFrame)
            self.fishFrame.removeFromSuperview()
            self.santaHatFrame.removeFromSuperview()
            self.santaBeardFrame.removeFromSuperview()
        case 2:
            filterView = santaBeardFrame
            self.view.addSubview(santaBeardFrame)
            self.view.bringSubview(toFront: santaBeardFrame)
            self.santaFrame.removeFromSuperview()
            self.santaHatFrame.removeFromSuperview()
            self.fishFrame.removeFromSuperview()
        case 3:
            filterView = santaHatFrame
            self.view.addSubview(santaHatFrame)
            self.view.bringSubview(toFront: santaHatFrame)
            self.santaFrame.removeFromSuperview()
            self.fishFrame.removeFromSuperview()
            self.santaBeardFrame.removeFromSuperview()
        default:
            self.view.addSubview(santaBeardFrame)
            self.view.bringSubview(toFront: santaBeardFrame)
            self.santaFrame.removeFromSuperview()
            self.santaHatFrame.removeFromSuperview()
            self.fishFrame.removeFromSuperview()
        }
        bringThemToFront()
    }
    
    func styleCaptureButton() {
        cameraButton.layer.borderColor = UIColor.black.cgColor
        cameraButton.layer.borderWidth = 5
        cameraButton.clipsToBounds = true
        cameraButton.layer.cornerRadius = min(cameraButton.frame.width, cameraButton.frame.height) / 2
        cameraButton.alpha = 0.4
    }
    
    func updateFish(newFaceBounds:CGRect){
        let pX = CGFloat(750-newFaceBounds.maxY)
        let pY = CGFloat(newFaceBounds.minX)
        self.followBounds = CGRect(x: pX/2, y: pY/2, width: newFaceBounds.size.width/2, height: newFaceBounds.size.height/2)
        self.fishFrame.frame = self.followBounds
        self.view.bringSubview(toFront: self.fishFrame)
        normalSortView()
    }
    
    func updateSanta(newFaceBounds:CGRect){
        let pX = CGFloat(750-newFaceBounds.maxY)
        let pY = CGFloat(newFaceBounds.minX)
        let pW = CGFloat(newFaceBounds.size.width/2)
        let pH = CGFloat(newFaceBounds.size.height/2)
        let newW:CGFloat = pW*4
        let newH:CGFloat = pH*4
        let newX:CGFloat = pX - pW*1.5 - 0.4*pW
        let newY:CGFloat = pY - pH*1.5 - 0.7*pH
        self.followBounds = CGRect(x: newX, y: newY, width: newW, height: newH)
        self.santaFrame.frame = self.followBounds
        self.view.bringSubview(toFront: self.santaFrame)
        normalSortView()
    }
    
    func updateSantaBeard(newFaceBounds:CGRect){
        let pX = CGFloat(750-newFaceBounds.maxY)
        let pY = CGFloat(newFaceBounds.minX+newFaceBounds.size.height)
        let oX = pX/2
        let oY = pY/2
        let oW = newFaceBounds.size.width/2
        let oH = newFaceBounds.size.height/2
        let nX = oX - oW/10
        let nY = oY - oH/10*5
        let nW = oW * 1.2
        let nH = oH * 1.2
        self.followBounds = CGRect(x: nX, y: nY, width: nW, height: nH)
        self.santaBeardFrame.frame = self.followBounds
        self.view.bringSubview(toFront: self.santaBeardFrame)
        normalSortView()
    }
    
    func updateSantaHat(newFaceBounds:CGRect){
        let pX = CGFloat(750-newFaceBounds.maxY)
        let pY = CGFloat(newFaceBounds.minX)
        let oX = pX/2
        let oY = pY/2
//        228:174
        let oW = newFaceBounds.size.width/2
        let oH = newFaceBounds.size.height/2
        let nW = oW * 1              * 1.2
        let nH = oH * 174.0/228.0    * 1.2
        let nX = oX - nW * 0.33
        let nY = oY - nH
        self.followBounds = CGRect(x: nX, y: nY, width: nW, height: nH)
        self.santaHatFrame.frame = self.followBounds
        self.view.bringSubview(toFront: self.santaHatFrame)
        normalSortView()
    }
    
    func noFish(){
        followBounds = CGRect(x: 0, y: 0, width: 0, height: 0)
        self.fishFrame.frame(forAlignmentRect: self.followBounds)
    }
    
    @IBAction func snapshot(_ sender: Any) {
        snapShotAndSaveView()
    }
    
    func mySmallSS(view:UIView)->UIImage{
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0.0)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    func mySS()->UIImage{
        UIGraphicsBeginImageContext(self.view.bounds.size)
        self.view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    func saveImage(image:UIImage){
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
    
    func snapShotAndSaveView(){
        let theImage:UIImage = mySmallSS(view: self.view)
        saveImage(image: theImage)
    }
    //
    

    func bringThemToFront(){
        let btnArr = [shotBtn,filterBtn,photoBtn]
//        @IBOutlet weak var shotBtn: UIButton!
//        @IBOutlet weak var filterBtn: UIButton!
//        @IBOutlet weak var photoBtn: UIButton!
        for btn in btnArr{
            self.view.bringSubview(toFront: btn!)
        }
    }
    
    @IBAction func cameraButton_TouchUpInside(_ sender: Any) {
        let settings = AVCapturePhotoSettings()
        self.visage?.shot()
//        self.saveImage(image: (self.visage?.image)!)
//        self.photoOutput?.capturePhoto(with: settings, delegate: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Preview_Segue" {
            let previewViewController = segue.destination as! PreviewViewController
            // now we draw the god damn things together
            let zero:UIImage = self.mySmallSS(view: self.view)
            var one:UIImage = (self.visage?.image?.ratioResizeForWidth(dWidth: zero.size.width))!
            let two:UIImage = self.mySmallSS(view: self.filterView)
            // 如果是背面的话，可能就不用
            // 翻转图片
            one = one.withHorizontallyFlippedOrientation()
//            let topImage:UIImage = mySmallSS(view: self.littleBar)
//            let middleImage:UIImage = myNewTestSS().ratioResizeForWidth(dWidth: topImage.size.width)
//            let downImage:UIImage = mySmallSS(view: self.completeDownViewForSnapshot).ratioResizeForWidth(dWidth: topImage.size.width)
            let newSize:CGSize = CGSize(width: zero.size.width, height: zero.size.height)
            UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
            one.draw(in: CGRect(x: 0, y: 0, width: zero.size.width, height: zero.size.height))
            two.draw(in: CGRect(x: self.filterView.frame.minX, y: self.filterView.frame.minY, width: self.filterView.frame.width, height: self.filterView.frame.height))
            let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            saveImage(image: image)
//            middleImage.draw(in: CGRect(x: 0, y: topImage.size.height,                             width: middleImage.size.width, height: middleImage.size.height))
//            topImage.draw(in: CGRect   (x: 0, y: 0,                                                width: topImage.size.width,    height: topImage.size.height))
//            downImage.draw(in: CGRect  (x: 0, y: (middleImage.size.height + topImage.size.height), width: downImage.size.width,   height: downImage.size.height))
//            let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
//            UIGraphicsEndImageContext()
            
            previewViewController.image = image
        }
        else if (segue.identifier == "toNavi"){
            let nextVC = segue.destination as! UINavigationController
            let smlVC = nextVC.topViewController as! FilterLibraryViewController
            smlVC.delegate = self
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        var myImage: UIImage!
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            myImage = image
        }
        else {
            // Error Message
        }
        //self.dismiss(animated: true, completion: nil)
        // 这段代码还有问题，不知道怎么转场到编辑
        func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "Preview_Segue" {
                let previewViewController = segue.destination as! PreviewViewController
                previewViewController.image = myImage
            }
        }

    }
    
    @IBAction func unwindToMainView(segue: UIStoryboardSegue) {}
    
}

//extension ViewController: AVCapturePhotoCaptureDelegate {
//    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
//        if let imageData = photo.fileDataRepresentation() {
//            self.image = UIImage(data: imageData)
//            performSegue(withIdentifier: "Preview_Segue", sender: nil)
//        }
//    }
//}

extension ViewController {
    //前后摄像头状态
    public enum CameraPosition {
        case front
        case rear
    }
}

extension ViewController:GetFilterValueDelegate {
    func getValue(_ controller: FilterLibraryViewController, FilterId: Int) {
        i = FilterId
        print("Filter的值是\(i)")
    }
}

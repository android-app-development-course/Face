//
//  ViewController.swift
//  Face1.1
//
//  Created by 刘友 on 2018/1/3.
//  Copyright © 2018年 刘友. All rights reserved.
//

import UIKit
import AVFoundation


class ViewController: UIViewController {
    
    @IBOutlet weak var cameraButton: UIButton!
    
    var captureSession = AVCaptureSession()
    //前后摄像头状态
    var currentCameraPosition: CameraPosition?
    
    var backCamera: AVCaptureDevice?
    
    var frontCamera: AVCaptureDevice?
    
    var currentDevice: AVCaptureDevice?
    
    var photoOutput: AVCapturePhotoOutput?
    
    var cameraPreviewLayer:AVCaptureVideoPreviewLayer?
    
    var image: UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
        setupPreviewLayer()
        captureSession.startRunning()
        
        
        styleCaptureButton()
        

    }
    
    
    func styleCaptureButton() {
        cameraButton.layer.borderColor = UIColor.white.cgColor
        cameraButton.layer.borderWidth = 5
        cameraButton.clipsToBounds = true
        cameraButton.layer.cornerRadius = min(cameraButton.frame.width, cameraButton.frame.height) / 2
    }
    
    func setupCaptureSession() {
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
    }
    
    func setupDevice() {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        let devices = deviceDiscoverySession.devices
        
        for device in devices {
            if device.position == AVCaptureDevice.Position.back {
                backCamera = device
            } else if device.position == AVCaptureDevice.Position.front {
                frontCamera = device
            }
        }
        currentDevice = backCamera
    }
    
    func setupInputOutput() {
        do {
            
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentDevice!)
            captureSession.addInput(captureDeviceInput)
            photoOutput = AVCapturePhotoOutput()
            photoOutput!.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecType.jpeg])], completionHandler: nil)
            captureSession.addOutput(photoOutput!)
            
            
        } catch {
            print(error)
        }
    }
    
    func setupPreviewLayer() {
        self.cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        self.cameraPreviewLayer?.frame = view.frame
        
        self.view.layer.insertSublayer(self.cameraPreviewLayer!, at: 0)
    }
    
    
    @IBAction func cameraButton_TouchUpInside(_ sender: Any) {
        let settings = AVCapturePhotoSettings()
        self.photoOutput?.capturePhoto(with: settings, delegate: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Preview_Segue" {
            let previewViewController = segue.destination as! PreviewViewController
            previewViewController.image = self.image
        }
    }
}

extension ViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation() {
            self.image = UIImage(data: imageData)
            performSegue(withIdentifier: "Preview_Segue", sender: nil)
        }
    }
}

extension ViewController {
    //前后摄像头状态
    public enum CameraPosition {
        case front
        case rear
    }
}


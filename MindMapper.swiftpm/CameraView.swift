//
//  ViewController.swift
//  myApp
//
//  Created by Rachit on 05/03/2023.
//

import UIKit
import SwiftUI
import AVFoundation
import Vision


class CameraView: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    private var permissionGranted = false // Flag for permission
    let captureSession = AVCaptureSession()
    let sessionQueue = DispatchQueue(label: "sessionQueue")
    var previewLayer = AVCaptureVideoPreviewLayer()
    var screenRect: CGRect! = nil // For view dimensions
    var resultDisplayed = false
    var level1_running = false
    var level2_running = false
    var level3_running = false
    var detectionArray: [Int] = []
    
    // Detector
    private var videoOutput = AVCaptureVideoDataOutput()
        
    //new request
    let handPoseRequest: VNDetectHumanHandPoseRequest = {
      // 1
      let request = VNDetectHumanHandPoseRequest()

      // 2
      request.maximumHandCount = 1
      return request
    }()
        
    var model: VNCoreMLModel! = nil
    var detectionLayer: CALayer! = nil
    
    var resultLayer: ResultViewController! = nil //result view
    var curObjects = 0 //limiting the number of objects
    let detectionQueue = DispatchQueue.global(qos: .userInteractive) //detection queue
    
      
    override func viewDidLoad() {
        checkPermission()
        sessionQueue.async { [unowned self] in
            guard permissionGranted else { return }
            self.setupCaptureSession()
            self.captureSession.startRunning()
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        resultLayer = ResultViewController(cameraView: self)
        resultLayer.isModalInPresentation = true
        resultLayer.modalPresentationStyle = .overCurrentContext
        resultLayer.modalTransitionStyle = .coverVertical
        present(resultLayer, animated: true, completion: nil)
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        

    }
    
    // 1
    var pointsProcessorHandler: (([CGPoint]) -> Void)?

    func processPoints(_ fingerTips: [CGPoint]) {
      // 2
      let convertedPoints = fingerTips.map {
        self.previewLayer.layerPointConverted(fromCaptureDevicePoint: $0)
      }

      // 3
      pointsProcessorHandler?(convertedPoints)
    }
    
    func checkPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            // Permission has been granted before
            case .authorized:
                permissionGranted = true
                
            // Permission has not been requested yet
            case .notDetermined:
                requestPermission()
                    
            default:
                permissionGranted = false
            }
    }
    
    func requestPermission() {
        sessionQueue.suspend()
        AVCaptureDevice.requestAccess(for: .video) { [unowned self] granted in
            self.permissionGranted = granted
            self.sessionQueue.resume()
        }
    }
    
    func setupCaptureSession() {
        // Camera input
        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else { return }
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice) else { return }
           
        guard captureSession.canAddInput(videoDeviceInput) else { return }
        captureSession.addInput(videoDeviceInput)
                         
        // Preview layer
        screenRect = UIScreen.main.bounds
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = CGRect(x: 0, y: 0, width: screenRect.size.width, height: (screenRect.height)/2 + 45)
        previewLayer.cornerRadius = 30
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill // Fill screen
        previewLayer.connection?.videoOrientation = .portrait
        
        // Detector
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "sampleBufferQueue"))
        captureSession.addOutput(videoOutput)
        
        videoOutput.connection(with: .video)?.videoOrientation = .portrait
        
        // Updates to UI must be on main queue
        DispatchQueue.main.async { [weak self] in
            self!.view.layer.addSublayer(self!.previewLayer)
        }
    }
}


struct HostCameraView: UIViewControllerRepresentable {
    var pointsProcessorHandler: (([CGPoint]) -> Void)?
    func makeUIViewController(context: Context) -> UIViewController {
        return CameraView()
        }

        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        }
}




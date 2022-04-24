//
//  File.swift
//  UIKit App
//
//  Created by Ikmal Azman on 19/04/2022.
//

import UIKit
import AVFoundation
import Vision
import ReplayKit

class LiveViewController : UIViewController {
    
    //MARK: - Variables
    private var captureSession : AVCaptureSession!
    private var backCameraDevice : AVCaptureDevice!
    private var backCameraInput : AVCaptureInput!
    private var videoPreviewLayer : AVCaptureVideoPreviewLayer!
    private var videoCameraDataOutput : AVCaptureVideoDataOutput!
    private var drawings: [UIVisualEffectView] = []
    private var spinner = UIActivityIndicatorView(style: .large)
    
    var videoPreviewView : UIView!
    
    var isTakeVideo = false {
        didSet {
            mainThread {
                self.didTapRecordButton()
            }
        }
    }
    
    var capturedImageView : UIImageView!
    var takeVideoButton : UIButton!
    var videoButtonView : UIView!
    let recorder = RPScreenRecorder.shared()
    
    //MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        checkPermission()
        view.backgroundColor = .primaryCream
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVideoPreviewView()
        setupCamera()
        setupVideoView()
        setupTakeVideoButton()
        setupCapturedImageView()
        setupSpinnerView()
    }
    
    func setupSpinnerView() {
        spinner.color = .systemBlue
        spinner.center = view.center
        view.addSubview(spinner)
    }
}

//MARK: - AVCaptureVideoDataOutputSampleBufferDelegate
// Method to receive samppleBuffer, monitor status, video data output
extension LiveViewController : AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        // Try and get CVImageBuffer from sample buffer,image buffer is a type representing Core Video buffers that hold images
        guard let cvBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {return}
        // Get CIImage from CVImageBuffer
        let ciImage = CIImage(cvImageBuffer: cvBuffer)
        
        // Handle process after image being captured
        backgroundThread {
            self.recognizeFaces(on: ciImage)
        }
    }
}
//MARK: - Vision Processing
extension LiveViewController {
    private func handleFaceDetectionResults(on image : CIImage, _ observedFaces: [VNFaceObservation]) {
        clearDrawings()
        
        let facesBoundingBoxes = observedFaces.map { faces -> UIVisualEffectView in
            let faceBoundingBoxOnScreen = self.videoPreviewLayer.layerRectConverted(fromMetadataOutputRect: faces.boundingBox)
            //    let faceBoundingBoxPath = CGPath(rect: faceBoundingBoxOnScreen, transform: nil)
            let blurEffect = UIBlurEffect(style: .light)
            let blurView = UIVisualEffectView(effect: blurEffect)
            blurView.contentView.layer.cornerRadius = 20
            blurView.frame = faceBoundingBoxOnScreen
            return blurView
        }
        
        facesBoundingBoxes.forEach { facesBoundingBox in
            self.view.addSubview(facesBoundingBox)
            self.view.layer.addSublayer(facesBoundingBox.layer)
        }
        self.drawings = facesBoundingBoxes
    }
    
    private func clearDrawings() {
        self.drawings.forEach { drawing in
            drawing.removeFromSuperview()
            drawing.layer.removeFromSuperlayer()
        }
    }
    
    func recognizeFaces(on image : CIImage) {
        let faceDetectionRequest = VNDetectFaceLandmarksRequest { [weak self] request, error in
            self?.mainThread {
                if let results = request.results as? [VNFaceObservation], results.count > 0 {
                    self?.handleFaceDetectionResults(on: image, results)
                    print("did detect \(results.count) face(s)")
                } else {
                    self?.clearDrawings()
                    print("did not detect any face")
                }
            }
        }
        let imageRequestHandler = VNImageRequestHandler(ciImage: image, orientation: .leftMirrored)
        try? imageRequestHandler.perform([faceDetectionRequest])
    }
}

//MARK: - RPPreviewViewControllerDelegate
extension LiveViewController : RPPreviewViewControllerDelegate {
    func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        previewController.dismiss(animated: true)
        navigationItem.hidesBackButton = false
    }
}

//MARK: - Private methods
extension LiveViewController {
    private func setupCameraInputs() {
        // Get back camera
        guard let backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {fatalError()}
        try? backCamera.lockForConfiguration()
        backCamera.activeVideoMinFrameDuration = CMTimeMake(value: 1, timescale: 24)
        backCamera.activeVideoMaxFrameDuration = CMTimeMake(value: 1, timescale: 30)
        backCameraDevice = backCamera
        
        // Create input object from specified device
        guard let backInput = try? AVCaptureDeviceInput(device: backCameraDevice) else {
            fatalError("There's some error when create input for back camera")
        }
        backCameraInput = backInput
        captureSession.addInput(backCameraInput)
        print("Input Connected")
    }
    
    private func setupVideoPreviewLayer() {
        // Layer di play video captured from input
        videoPreviewLayer = AVCaptureVideoPreviewLayer()
        videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        // Connect video layer to capture session
        videoPreviewLayer.session = captureSession
        
        // Add preview layer inside videoPreviewView
        videoPreviewView.layer.addSublayer(videoPreviewLayer)
        videoPreviewLayer.frame = self.videoPreviewView.frame
    }
    
    private func setupCameraOutputs() {
        // Init output, allow to get data recorded from video and access the frame rates for processing
        videoCameraDataOutput = AVCaptureVideoDataOutput()
        // Create new dispatch queue, object manage execution task, allow to be call at the frame-rate of the camera, expect to process data background thread
        let videoQueue = DispatchQueue(label: "videoQueue", qos: .background)
        // Set sampleBufferDelegate and initialise the queue for system to call the function back
        videoCameraDataOutput.setSampleBufferDelegate(self, queue: videoQueue)
        
        // Determine if output can be added to capture session
        if captureSession.canAddOutput(videoCameraDataOutput) {
            captureSession.addOutput(videoCameraDataOutput)
        } else {
            fatalError("Could not add video output")
        }
        // Make the preview image orientation in portrait, correct video orientation when take a picture
        videoCameraDataOutput.connections.first?.videoOrientation = .portrait
        print("Output Connected")
    }
    
    private func setupCamera() {
        // Execute config in bg thread
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            // Init capture session
            self?.captureSession = AVCaptureSession()
            // Start configure capture session
            self?.captureSession.beginConfiguration()
            // Set quality level of the output
            self?.captureSession.sessionPreset = .hd1920x1080
            // Enable wide color of photo for output
            self?.captureSession.automaticallyConfiguresCaptureDeviceForWideColor = true
            // Setup camera device inputs(AVCaptureInput)
            self?.setupCameraInputs()
            
            // Set the preview is in UI, so it need to run on the main thread
            DispatchQueue.main.async { [weak self] in
                self?.setupVideoPreviewLayer()
            }
            // Setup camera device output (Data that retrieved from capture device via its mediator, CaptureSession)
            self?.setupCameraOutputs()
            // Commit configuration that had been made
            self?.captureSession.commitConfiguration()
            // Start running the capture session
            self?.captureSession.startRunning()
        }
    }
    
    private func checkPermission() {
        // Return value that the app has permission to access specific mediaType
        let checkCameraAuthStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch checkCameraAuthStatus {
        case .notDetermined:
            // Request user permission if access not yet determine
            AVCaptureDevice.requestAccess(for: .video) { allowAccess in
                if !allowAccess {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                }
            }
        case .restricted:
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        case .denied:
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        case .authorized:
            return
        @unknown default:
            fatalError("There some error when request camera permission from user")
        }
    }
    
    func setButtonImage(_ systemName : String, size : CGFloat = 80 ) -> UIImage? {
        let font = UIFont.systemFont(ofSize: 80)
        let config = UIImage.SymbolConfiguration(font: font)
        let buttonImage = UIImage(systemName: systemName, withConfiguration: config)
        return buttonImage
    }
    
    func setupTakeVideoButton() {
        takeVideoButton = UIButton()
        takeVideoButton.tintColor = .white
        takeVideoButton.translatesAutoresizingMaskIntoConstraints = false
        takeVideoButton.setImage(self.setButtonImage("circle.fill"), for: .normal)
        
        takeVideoButton.setTitle("", for: .normal)
        let action = UIAction(handler: { _ in
            print("isTakePicture : \(self.isTakeVideo)")
            self.isTakeVideo.toggle()
            
        })
        takeVideoButton.addAction(action, for: .touchUpInside)
        videoButtonView.addSubview(takeVideoButton)
        
        NSLayoutConstraint.activate([
            takeVideoButton.centerXAnchor.constraint(equalTo: videoButtonView.centerXAnchor),
            takeVideoButton.bottomAnchor.constraint(equalTo: videoButtonView.bottomAnchor),
            takeVideoButton.heightAnchor.constraint(equalToConstant: 75),
            takeVideoButton.widthAnchor.constraint(equalToConstant: 75)
        ])
    }
    
    func didTapRecordButton() {
        if isTakeVideo == true {
            // Hide navbar back button
            navigationItem.hidesBackButton = true
            capturedImageView.isHidden = true
            self.takeVideoButton.setImage(self.setButtonImage("stop.circle"), for: .normal)
            takeVideoButton.tintColor = .red
            // Start record
            recorder.isMicrophoneEnabled = true
            recorder.startRecording { error in
                if let error = error {
                    print("Error : \(error)")
                }
            }
        } else if isTakeVideo == false {
            // Hide navbar back button
            navigationItem.hidesBackButton = false
#warning("Unhide image view")
            //capturedImageView.isHidden = false
            spinner.startAnimating()
            takeVideoButton.setImage(setButtonImage("circle.fill"), for: .normal)
            takeVideoButton.tintColor = .white
            // Stop record
            recorder.stopRecording { [weak self] previewVC, error in
                if let error = error {
                    print("Error :\(error)")
                    return
                }
                if let previewVC = previewVC {
                    self?.spinner.stopAnimating()
                    previewVC.previewControllerDelegate = self
                    previewVC.modalPresentationStyle = .fullScreen
                    self?.present(previewVC, animated: true)
                }
            }
        }
    }
    
    
    func setupCapturedImageView() {
        capturedImageView = UIImageView()
#warning("Hide image view")
        capturedImageView.isHidden = true
        capturedImageView.contentMode = .scaleAspectFit
        capturedImageView.image = UIImage(systemName: "photo.fill.on.rectangle.fill")
        capturedImageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(capturedImageView)
        NSLayoutConstraint.activate([
            capturedImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            capturedImageView.widthAnchor.constraint(equalToConstant: 50),
            capturedImageView.heightAnchor.constraint(equalToConstant: 50),
            capturedImageView.centerYAnchor.constraint(equalTo: takeVideoButton.centerYAnchor)
        ])
    }
    
    func setupVideoPreviewView() {
        videoPreviewView = UIView()
        videoPreviewView.backgroundColor = .clear
        view.addSubview(videoPreviewView)
        videoPreviewView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            videoPreviewView.topAnchor.constraint(equalTo: view.topAnchor),
            videoPreviewView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            videoPreviewView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            videoPreviewView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func setupVideoView() {
        videoButtonView = createSimpleUIView(.clear)
        videoButtonView.layer.cornerRadius = 10
        videoButtonView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(videoButtonView)
        
        NSLayoutConstraint.activate([
            videoButtonView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
            videoButtonView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            videoButtonView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            videoButtonView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
}

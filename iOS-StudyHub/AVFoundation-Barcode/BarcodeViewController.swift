//
//  BarcodeViewController.swift
//  iOS-StudyHub
//
//  Created by 최민준(Minjun Choi) on 4/2/25.
//

import UIKit
import AVFoundation

class BarcodeViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    @IBOutlet weak var barcodeReadingView: UIView!
    
    var captureSession: AVCaptureSession?
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        DispatchQueue.main.async {
            self.startBarcodeReading()
        }
    }
    
    private func startBarcodeReading() {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        
        if let sublayers = self.barcodeReadingView.layer.sublayers {
            for layer in sublayers  {
                (layer as? AVCaptureVideoPreviewLayer)?.removeFromSuperlayer()
            }
        }
        
        let innput:AVCaptureDeviceInput
        let output:AVCaptureMetadataOutput = AVCaptureMetadataOutput()
        
        do {
            innput = try AVCaptureDeviceInput(device: device)
        } catch let error {
            print(error.localizedDescription)
            return
        }
        
        let captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo
        captureSession.addInput(innput)
        captureSession.addOutput(output)
        self.captureSession = captureSession
        
        let preview = AVCaptureVideoPreviewLayer(session: captureSession)
        preview.videoGravity = AVLayerVideoGravity.resizeAspectFill
        preview.frame = self.barcodeReadingView.layer.bounds
        self.barcodeReadingView.layer.addSublayer(preview)
        DispatchQueue.global().async {
            captureSession.startRunning()
        }
    }
}

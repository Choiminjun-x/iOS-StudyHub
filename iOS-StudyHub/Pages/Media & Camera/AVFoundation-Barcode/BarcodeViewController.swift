//
//  BarcodeViewController.swift
//  iOS-StudyHub
//
//  Created by 최민준(Minjun Choi) on 4/2/25.
//

import UIKit
import AVFoundation

class BarcodeViewController: UIViewController {
    
    @IBOutlet weak var barcodeReadingContainer: UIView!
    
    var captureSession: AVCaptureSession?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            self.startBarcodeReading()
        }
    }
    
    private func startBarcodeReading() {
        DispatchQueue.main.async {
            self.setupCamera()
        }
    }
    
    private func stopBarcodeReading() {
        if (self.captureSession != nil), (self.captureSession?.isRunning)! {
            self.captureSession?.stopRunning()
            self.captureSession = nil
        }
    }
    
    private func setupCamera() {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        
        if let sublayers = self.barcodeReadingContainer.layer.sublayers {
            for layer in sublayers  {
                (layer as? AVCaptureVideoPreviewLayer)?.removeFromSuperlayer()
            }
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: device)
            let output = AVCaptureMetadataOutput()
            
            let captureSession = AVCaptureSession()
            captureSession.sessionPreset = .photo
            
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            }
            
            if captureSession.canAddOutput(output) {
                captureSession.addOutput(output)
                output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                output.metadataObjectTypes = [
                    .ean8,
                    .ean13,
                    .code128
                ]
            }
            
            self.captureSession = captureSession
            
            let preview = AVCaptureVideoPreviewLayer(session: captureSession)
            preview.videoGravity = AVLayerVideoGravity.resizeAspectFill
            preview.frame = self.barcodeReadingContainer.layer.bounds
            self.barcodeReadingContainer.layer.addSublayer(preview)
            DispatchQueue.global().async {
                captureSession.startRunning()
            }
        } catch let error {
            print("Error setting up camera: \(error.localizedDescription)")
            return
        }
    }
}

extension BarcodeViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard !metadataObjects.isEmpty,
              let codeobj: AVMetadataMachineReadableCodeObject = metadataObjects[0] as? AVMetadataMachineReadableCodeObject,
              codeobj.type == AVMetadataObject.ObjectType.ean8
                || codeobj.type == AVMetadataObject.ObjectType.ean13
                || codeobj.type == AVMetadataObject.ObjectType.code128 else {
            return
        }
        
        self.stopBarcodeReading()
        
        if let barcodeValue = codeobj.stringValue {
            // 바코드 감지 시 처리
        }
    }
}

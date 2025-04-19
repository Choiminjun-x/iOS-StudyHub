//
//  BarcodeViewController.swift
//  iOS-StudyHub
//
//  Created by 최민준(Minjun Choi) on 4/2/25.
//

import UIKit
import AVFoundation

class BarcodeViewController: UIViewController {

    @IBOutlet weak var barcodeReadingView: UIView! // 카메라 프리뷰를 보여줄 뷰
    
    var captureSession: AVCaptureSession? // 캡처 세션을 저장할 변수
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 뷰가 로드된 후 카메라 세션 시작
        DispatchQueue.main.async {
            self.startBarcodeReading()
        }
    }
    
    private func startBarcodeReading() {
        // 비디오(카메라) 타입의 기본 디바이스 가져오기
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        
        // 기존에 추가된 AVCaptureVideoPreviewLayer가 있다면 제거 (중복 방지)
        if let sublayers = self.barcodeReadingView.layer.sublayers {
            for layer in sublayers {
                (layer as? AVCaptureVideoPreviewLayer)?.removeFromSuperlayer()
            }
        }
        
        let output: AVCaptureMetadataOutput = AVCaptureMetadataOutput() // 메타데이터 출력 객체 생성
        
        // 현재 디바이스에서 지원하는 메타데이터 타입 중 바코드 관련된 것만 필터링
        let supportedTypes = output.availableMetadataObjectTypes
        output.metadataObjectTypes = supportedTypes.filter {
            [.ean8, .ean13, .code128, .qr].contains($0)
        }
        
        // 메타데이터 출력에 대한 델리게이트 설정 (바코드 인식 결과 전달을 위해)
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        let input: AVCaptureDeviceInput
        do {
            // 카메라 입력 초기화
            input = try AVCaptureDeviceInput(device: device)
        } catch let error {
            print(error.localizedDescription)
            return
        }
        
        // 캡처 세션 생성 및 입력/출력 연결
        let captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo // 세션 프리셋 설정 (사진 품질 수준)
        captureSession.addInput(input)
        captureSession.addOutput(output)
        self.captureSession = captureSession
        
        // 카메라 화면 미리보기를 위한 레이어 생성 및 추가
        let preview = AVCaptureVideoPreviewLayer(session: captureSession)
        preview.videoGravity = AVLayerVideoGravity.resizeAspectFill
        preview.frame = self.barcodeReadingView.layer.bounds
        self.barcodeReadingView.layer.addSublayer(preview)
        
        // 백그라운드 스레드에서 세션 시작
        DispatchQueue.global().async {
            captureSession.startRunning()
        }
    }
}

extension BarcodeViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    // 바코드가 인식되었을 때 호출되는 델리게이트 메서드
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // 인식되면 세션 중지 (중복 인식 방지)
        captureSession?.stopRunning()
        
        // 첫 번째 인식된 메타데이터 객체에서 문자열 추출
        if let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
           let barcodeValue = metadataObject.stringValue {
            print("바코드 값: \(barcodeValue)")
            // 여기서 다음 화면으로 전환하거나 필요한 로직 수행 가능
        }
    }
}

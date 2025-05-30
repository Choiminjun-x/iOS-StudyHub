//
//  WebViewController.swift
//  iOS-StudyHub
//
//  Created by 최민준(Minjun Choi) on 5/28/25.
//

import UIKit
import WebKit
import Combine
import SnapKit

class WebViewController: UIViewController {

    private var webView: WKWebView!
    
    private let interfaceSubject = PassthroughSubject<WKScriptMessage, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    private enum RequestType: String, CaseIterable {
        case requestExit = "requestExit" // 웹뷰 종료
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.interfaceSubscription()
        self.setUpWebView()
    }
    
    private func setUpWebView() {
        let urlRequest = URLRequest(url: "www.apple.com".url()!)
        let configuration = self.webViewConfiguration()
        self.addScriptMessages(to: configuration)
        self.webView = self.addWebView(urlRequest: urlRequest, configuration: configuration)
    }
    
    private func addWebView(urlRequest: URLRequest, configuration: WKWebViewConfiguration) -> WKWebView {
        return WKWebView(frame: .zero, configuration: configuration).do {
            $0.backgroundColor = .white
            
            /// iOS 16.4+: Safari Web Inspector 사용 가능 (디버깅 목적)
            if #available(iOS 16.4, *) {
                $0.isInspectable = true
            }
            self.view.addSubview($0)
            $0.snp.makeConstraints {
                $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
                $0.bottom.leading.trailing.equalToSuperview()
            }
            
            // URL 로드
            $0.load(urlRequest)
            self.view.layoutIfNeeded()
        }
    }
    
    /// WKWebView 설정 생성 (UserAgent, JavaScript, Media 등 포함)
    private func webViewConfiguration() -> WKWebViewConfiguration {
        let configuration = WKWebViewConfiguration()
        let userContent = WKUserContentController() // JS <-> Native 메시지 핸들러 연결
        let preference = WKPreferences() // JavaScript 실행 설정, 새 창 허용 등
        
        preference.javaScriptEnabled = true // 자바스크립트 사용 허용
        preference.javaScriptCanOpenWindowsAutomatically = true // JS에서 window.open 호출 허용
                
        configuration.applicationNameForUserAgent = "com.devchoi.iOS-StudyHub" // 사용자 에이전트 커스터마이징 (웹에서 식별 가능) -> 서버 측에서 UserAgent로 앱 식별 가능
        configuration.preferences = preference  // 위 설정된 preference 연결
        configuration.userContentController = userContent  // JS 메시지 핸들러 연결용 컨트롤러
        configuration.allowsInlineMediaPlayback = true  // 인라인 비디오 재생 허용 (예: <video> 태그 자동 재생 등)
        configuration.allowsPictureInPictureMediaPlayback = false // PIP (Picture-In-Picture) 사용 금지
        
        return configuration
    }
    
    private func addScriptMessages(to configuration: WKWebViewConfiguration) {
        /// Swift에 JavaScript 인터페이스 연결
        RequestType.allCases.forEach {
            configuration.userContentController.add(self, name: $0.rawValue)
        }
    }
}

extension WebViewController: WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        self.interfaceSubject.send(message)
    }
    
    private func interfaceSubscription() {
        self.interfaceSubject.sink { [weak self] interfaces in
            self?.processInterfaceMessage(interfaces)
        }.store(in: &cancellables)
    }
    
    private func processInterfaceMessage(_ message: WKScriptMessage) {
        guard let type = RequestType(rawValue: message.name) else { return }
        
        switch type {
        case .requestExit:
            self.dismiss(animated: true)
            break
        }
    }
}

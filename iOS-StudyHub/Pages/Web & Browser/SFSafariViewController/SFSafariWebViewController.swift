//
//  SFSafariWebViewController.swift
//  iOS-StudyHub
//
//  Created by 최민준(Minjun Choi) on 6/5/25.
//

import UIKit
@preconcurrency import WebKit
import SafariServices

class SFSafariWebViewController: UIViewController {
    
    private var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        self.setUpWebView()
        self.loadSimplePage()
    }
    
    private func setUpWebView() {
        let urlRequest = URLRequest(url: "www.apple.com".url()!)
        self.webView = self.addWebView(urlRequest: urlRequest)
    }
    
    private func addWebView(urlRequest: URLRequest) -> WKWebView {
        return WKWebView(frame: .zero).do {
            $0.backgroundColor = .white
            $0.navigationDelegate = self
            
            /// iOS 16.4+: Safari Web Inspector 사용 가능 (디버깅 목적)
            if #available(iOS 16.4, *) {
                $0.isInspectable = true
            }
            
            self.view.addSubview($0)
            $0.snp.makeConstraints {
                $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
                $0.bottom.leading.trailing.equalToSuperview()
            }
        }
    }
    
    private func loadSimplePage() {
        let html = """
         <html>
         <head>
             <style>
                 body {
                     display: flex;
                     justify-content: center;
                     align-items: center;
                     height: 100vh;
                     font-family: -apple-system, sans-serif;
                     background-color: #f9f9f9;
                 }
                 a {
                     display: inline-block;
                     font-size: 24px;
                     padding: 20px 40px;
                     background-color: #007aff;
                     color: white;
                     text-decoration: none;
                     border-radius: 12px;
                 }
                 a:hover {
                     background-color: #0051cb;
                 }
             </style>
         </head>
         <body>
             <a href="https://www.apple.com">Apple.com 열기</a>
         </body>
         </html>
         """
        self.webView.loadHTMLString(html, baseURL: nil)
    }
}

extension SFSafariWebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        guard let url = navigationAction.request.url else {
            decisionHandler(.allow)
            return
        }
        
        if navigationAction.navigationType == .linkActivated {
            let safariVC = SFSafariViewController(url: url)
            self.present(safariVC, animated: true)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
}

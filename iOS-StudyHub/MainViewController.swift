//
//  MainViewController.swift
//  iOS-StudyHub
//
//  Created by 최민준 on 5/30/25.
//

import UIKit

class MainViewController: UIViewController {

    private func setUpNavigationItem() {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUpNavigationItem()
    }
    
    
    /// InfiniteRollingBanner
    @IBAction func onClickMenu1(_ sender: Any) {
        let page = BannerViewController()
        self.navigationController?.pushViewController(page, animated: true)
    }
    
    /// AVFoundation-Barcode
    @IBAction func onClickMenu2(_ sender: Any) {
        let page = BarcodeViewController()
        self.navigationController?.pushViewController(page, animated: true)
    }
    
    /// ImageCache
    @IBAction func onClickMenu3(_ sender: Any) {
        let page = ImageCacheTestViewController()
        self.navigationController?.pushViewController(page, animated: true)
    }

    /// WebView - Webkit
    @IBAction func onClickMenu4(_ sender: Any) {
        let page = WebViewController()
        self.navigationController?.pushViewController(page, animated: true)
    }
    
}

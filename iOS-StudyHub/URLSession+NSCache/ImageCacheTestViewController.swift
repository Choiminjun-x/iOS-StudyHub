//
//  ImageCacheTestViewController.swift
//  iOS-StudyHub
//
//  Created by 최민준(Minjun Choi) on 5/29/25.
//

import UIKit
import SnapKit

class ImageCacheTestViewController: UIViewController {
    
    private let testImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.view.addSubview(self.testImageView)
        
        self.testImageView.frame = CGRect(x: 50, y: 100, width: 200, height: 200)
        self.testImageView.contentMode = .scaleAspectFit
        
        let imageURL = URL(string: "https://picsum.photos/id/1/300/200")! // 고정 이미지 url
        
        self.testImageView.setImage(from: imageURL)
    }
}

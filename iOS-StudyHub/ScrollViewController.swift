//
//  ScrollViewController.swift
//  iOS-StudyHub
//
//  Created by 최민준 on 4/5/25.
//

import UIKit

class ScrollViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.scrollView.contentInset = .init(top: 100, left: 0, bottom: 0, right: 0)
    }
}

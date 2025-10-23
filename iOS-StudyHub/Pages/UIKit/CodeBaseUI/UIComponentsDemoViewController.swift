//
//  LayoutShowCaseViewController.swift
//  iOS-StudyHub
//
//  Created by 최민준(Minjun Choi) on 8/21/25.
//

import UIKit

class UIComponentsDemoViewController: UIViewController {

    
    // MARK: instantiate
    
    deinit {
        print(type(of: self), #function)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.initViewLayout()
        self.configure()
    }
    
    
    // MARK: initViewLayout
    
    private func initViewLayout() {
        self.view.backgroundColor = .white
        
        let demoView = UIComponentsDemoView.create()
        self.view.addSubview(demoView)
        demoView.snp.makeConstraints {
            $0.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    
    // MARK: configure
    
    private func configure() {
        
    }
}

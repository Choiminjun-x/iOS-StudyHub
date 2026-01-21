//
//  HomeViewController.swift
//  iOS-StudyHub
//
//  Created by 최민준(Minjun Choi) on 1/21/26.
//

import UIKit

final class HomeViewController: UIViewController {
    
    // MARK: View Event Handling
    
    private var viewEventLogic: HomeViewEventLogic { self.view as! HomeViewEventLogic }
    private var viewDisplayLogic: HomeViewDisplayLogic { self.view as! HomeViewDisplayLogic }
    
    // MARK: instantiate
    
    deinit {
        print(type(of: self), #function)
    }
    
    // MARK: Setup Navigation
    
    private func setupNavigation() {
        
    }
    
    // MARK: View lifecycle
    
    override func loadView() {
        self.view = HomeView.create()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

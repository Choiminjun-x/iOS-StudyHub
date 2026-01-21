//
//  CalendarViewController.swift
//  iOS-StudyHub
//
//  Created by 최민준(Minjun Choi) on 1/21/26.
//

import UIKit
import Combine

protocol CalendarPresentableListener: AnyObject {
    func requestCalendarInfo()
//    func requestTodos()
//    func didTapRefreshButton()
//    func didTapTodoItem(todo: Todo?)
//    func didToggleTodo(id: Int)
}

final class CalendarViewController: UIViewController, CalendarViewControllable, CalendarPresentable {
    
    var listener: CalendarPresentableListener?
    
    var viewController: UIViewController { return self }

    // MARK: View Event Handling
    
    private var viewEventLogic: CalendarViewEventLogic { self.view as! CalendarViewEventLogic }
    private var viewDisplayLogic: CalendarViewDisplayLogic { self.view as! CalendarViewDisplayLogic }
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: instantiate
    private let dateGenerator: DateGenerator
    
    init(dateGenerator: DateGenerator) {
        self.dateGenerator = dateGenerator
        super.init(nibName: nil, bundle: nil)
        self.setupNavigation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    deinit {
        print(type(of: self), #function)
    }
    
    // MARK: Setup Navigation
    
    private func setupNavigation() {
        
    }
    
    // MARK: View lifecycle
    
    override func loadView() {
        self.view = CalendarView.create(with: dateGenerator)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewDisplayLogic.do {
            $0.displayMonthInfo.sink { text in
                self.navigationItem.title = text
            }.store(in: &cancellables)
        }
    }
    
    func updateDays(_ days: [[CalendarDay]]) {
        self.viewDisplayLogic.displayPageInfo(days)
    }
}

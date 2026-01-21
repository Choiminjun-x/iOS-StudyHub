//
//  CalendarInteractor.swift
//  iOS-StudyHub
//
//  Created by 최민준(Minjun Choi) on 1/21/26.
//

import Foundation
import RIBs

protocol CalendarRouting: ViewableRouting {
//    func attachTodoListDetail()
//    func detachTodoListDetail()
}

protocol CalendarPresentable: Presentable {
    var listener: CalendarPresentableListener? { get set }
    
//    // 정보 업데이트 -> ViewController 전달
    func updateDays(_ days: [CalendarDay])
//    func showError(_ message: String)
}

public protocol CalendarListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

class CalendarInteractor: PresentableInteractor<CalendarPresentable>, CalendarInteractable, CalendarPresentableListener {
    
    var router: CalendarRouting?
    var listener: CalendarListener?
    
    private let dateProvider: CalendarDateProviding
 
    init(presenter: CalendarPresentable, dateProvider: CalendarDateProviding) {
        self.dateProvider = dateProvider
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        
        self.requestCalendarInfo()
    }
    
    func requestCalendarInfo() {
        let days = self.dateProvider.generateCurrentMonthDays()
        // 최초 캘린더 호출
        self.presenter.updateDays(days)
    }
    
}

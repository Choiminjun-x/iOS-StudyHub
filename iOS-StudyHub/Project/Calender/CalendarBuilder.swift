//
//  CalendarBuilder.swift
//  iOS-StudyHub
//
//  Created by 최민준(Minjun Choi) on 1/21/26.
//

import Foundation
import RIBs

protocol CalendarDependency: Dependency {
    var dateProvider: CalendarDateProviding { get }
}

final class CalendarComponent: Component<CalendarDependency> {
    var dateProvider: CalendarDateProviding { dependency.dateProvider }
}

public protocol CalendarBuildable: Buildable {
    func build(withListener listener: CalendarListener) -> ViewableRouting
}

class CalendarBuilder: Builder<CalendarDependency>, CalendarBuildable {
    
    public override init(dependency: CalendarDependency) {
      super.init(dependency: dependency)
    }
    
    public func build(withListener listener: CalendarListener) -> ViewableRouting {
        let component = CalendarComponent(dependency: dependency)
        let viewController = CalendarViewController(dateProvider: component.dateProvider)
        let interactor = CalendarInteractor(presenter: viewController, dateProvider: component.dateProvider)
        interactor.listener = listener
        
        return CalendarRouter(interactor: interactor,
                              viewController: viewController)
    }
}

//
//  CalendarDateProvider.swift
//  iOS-StudyHub
//
//  Created by 최민준(Minjun Choi) on 1/21/26.
//

import Foundation

struct CalendarDay {
    let date: Date
    let isInCurrentMonth: Bool
    
    var isToday: Bool {
          Calendar.current.isDateInToday(date)
      }
}

protocol CalendarDateProviding {
    // generate - Network, DB 요청 X
    func generateCurrentMonthDays() -> [CalendarDay]
}

final class CalendarDateProvider: CalendarDateProviding {
    private let calendar = Calendar.current
    
    func generateCurrentMonthDays() -> [CalendarDay] {
        let today = Date()
        guard let monthInterval = calendar.dateInterval(of: .month, for: today),
              let firstWeekday = calendar.dateComponents([.weekday], from: monthInterval.start).weekday else {
            return []
        }

        var days: [CalendarDay] = []

        // 이전 달의 일부 날짜 채우기
        let previousDaysCount = firstWeekday - calendar.firstWeekday
        for i in stride(from: previousDaysCount, to: 0, by: -1) {
            if let date = calendar.date(byAdding: .day, value: -i, to: monthInterval.start) {
                days.append(CalendarDay(date: date, isInCurrentMonth: false))
            }
        }

        // 이번 달 날짜 채우기
        var currentDate = monthInterval.start
        while currentDate < monthInterval.end {
            days.append(CalendarDay(date: currentDate, isInCurrentMonth: true))
            guard let nextDay = calendar.date(byAdding: .day, value: 1, to: currentDate) else { break }
            currentDate = nextDay
        }

        // 다음 달의 일부 날짜 채우기 (최대 6행 맞추기 위해)
        while days.count % 7 != 0 {
            if let next = calendar.date(byAdding: .day, value: 1, to: currentDate) {
                days.append(CalendarDay(date: next, isInCurrentMonth: false))
                currentDate = next
            } else {
                break
            }
        }

        return days
    }
}

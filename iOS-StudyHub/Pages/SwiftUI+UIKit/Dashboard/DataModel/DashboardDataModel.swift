
//
//  DashboardDataModel.swift
//  iOS-StudyHub
//
//  Created by 최민준(Minjun Choi) on 8/21/25.
//

import Foundation

// MARK: - 데이터 모델들

/// 차트 데이터 포인트
struct DataPoint: Identifiable, Codable {
    let id = UUID()
    let timestamp: Date
    let value: Double
    let label: String?
    
    init(value: Double, label: String? = nil) {
        self.timestamp = Date()
        self.value = value
        self.label = label
    }
}

/// 대시보드 메트릭
struct DashboardMetric: Identifiable {
    let id = UUID()
    let title: String
    let value: Double
    let unit: String
    let change: Double // 변화율 (%)
    let isPositive: Bool // 양수/음수 여부
    let icon: String // SF Symbol 이름
    
    init(title: String, value: Double, unit: String, change: Double, icon: String) {
        self.title = title
        self.value = value
        self.unit = unit
        self.change = change
        self.icon = icon
        self.isPositive = change >= 0
    }
}

/// 차트 타입
enum ChartType: String, CaseIterable {
    case line = "라인 차트"
    case bar = "바 차트"
    case area = "영역 차트"
}

/// 시간 범위
enum TimeRange: String, CaseIterable {
    case realTime = "실시간"
    case lastHour = "최근 1시간"
    case lastDay = "최근 24시간"
    case lastWeek = "최근 7일"
}

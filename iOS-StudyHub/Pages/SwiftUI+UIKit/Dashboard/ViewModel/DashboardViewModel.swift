
//
//  DashboardViewModel.swift
//  iOS-StudyHub
//
//  Created by 최민준(Minjun Choi) on 8/21/25.
//

import Foundation
import Combine

/// 대시보드 뷰모델 - 실시간 데이터 관리
class DashboardViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var metrics: [DashboardMetric] = []
    @Published var chartData: [DataPoint] = []
    @Published var isLoading: Bool = false
    @Published var selectedChartType: ChartType = .line
    @Published var selectedTimeRange: TimeRange = .realTime
    @Published var lastUpdated: Date = Date()
    
    // MARK: - Private Properties
    private var timer: Timer?
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init() {
        setupInitialData()
        startRealTimeUpdates()
    }
    
    deinit {
        stopRealTimeUpdates()
    }
    
    // MARK: - Public Methods
    
    /// 실시간 업데이트 시작
    func startRealTimeUpdates() {
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            self?.updateData()
        }
    }
    
    /// 실시간 업데이트 중지
    func stopRealTimeUpdates() {
        timer?.invalidate()
        timer = nil
    }
    
    /// 차트 타입 변경
    func changeChartType(_ type: ChartType) {
        selectedChartType = type
    }
    
    /// 시간 범위 변경
    func changeTimeRange(_ range: TimeRange) {
        selectedTimeRange = range
        updateData()
    }
    
    // MARK: - Private Methods
    
    /// 초기 데이터 설정
    private func setupInitialData() {
        updateData()
    }
    
    /// 데이터 업데이트 (실제로는 API 호출)
    private func updateData() {
        DispatchQueue.main.async { [weak self] in
            self?.isLoading = true
            
            // 시뮬레이션된 API 호출
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self?.generateMockData()
                self?.isLoading = false
                self?.lastUpdated = Date()
            }
        }
    }
    
    /// 모의 데이터 생성
    private func generateMockData() {
        // 메트릭 데이터 생성
        metrics = [
            DashboardMetric(
                title: "총 사용자",
                value: Double.random(in: 1000...5000),
                unit: "명",
                change: Double.random(in: -10...15),
                icon: "person.3.fill"
            ),
            DashboardMetric(
                title: "활성 세션",
                value: Double.random(in: 50...500),
                unit: "개",
                change: Double.random(in: -5...20),
                icon: "play.circle.fill"
            ),
            DashboardMetric(
                title: "수익",
                value: Double.random(in: 10000...100000),
                unit: "원",
                change: Double.random(in: -15...25),
                icon: "dollarsign.circle.fill"
            ),
            DashboardMetric(
                title: "전환율",
                value: Double.random(in: 1...10),
                unit: "%",
                change: Double.random(in: -2...5),
                icon: "chart.line.uptrend.xyaxis"
            )
        ]
        
        // 차트 데이터 생성
        let newDataPoint = DataPoint(
            value: Double.random(in: 0...100),
            label: "현재"
        )
        
        // 최대 20개 데이터 포인트 유지
        if chartData.count >= 20 {
            chartData.removeFirst()
        }
        chartData.append(newDataPoint)
    }
}

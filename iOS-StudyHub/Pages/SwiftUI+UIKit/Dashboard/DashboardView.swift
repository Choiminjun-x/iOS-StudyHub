//
//  DashboardView.swift
//  iOS-StudyHub
//
//  Created by 최민준(Minjun Choi) on 8/21/25.
//

import SwiftUI

/// 대시보드 SwiftUI 뷰
struct DashboardView: View {
    
    @StateObject private var viewModel = DashboardViewModel()
    @State private var showingSettings = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // 헤더 정보
                    headerView
                    
                    // 메트릭 카드들
                    metricsGridView
                    
                    // 차트 섹션
                    chartSectionView
                    
                    // 실시간 상태 표시
                    statusView
                }
                .padding()
            }
            .sheet(isPresented: $showingSettings) {
                settingsView
            }
        }
    }
    
    // MARK: - Header View
    private var headerView: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .foregroundColor(.blue)
                    .font(.title2)
                
                Text("실시간 모니터링")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(0.8)
                }
            }
            
            Text("마지막 업데이트: \(viewModel.lastUpdated, formatter: timeFormatter)")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    // MARK: - Metrics Grid
    private var metricsGridView: some View {
        LazyVGrid(columns: [ // iOS 14.0+
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 16) {
            ForEach(viewModel.metrics) { metric in
                MetricCardView(metric: metric)
            }
        }
    }
    
    // MARK: - Chart Section
    private var chartSectionView: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("실시간 차트")
                    .font(.headline)
                    .fontWeight(.bold)
                
                Spacer()
                
                Picker("차트 타입", selection: $viewModel.selectedChartType) {
                    ForEach(ChartType.allCases, id: \.self) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: 200)
            }
            
            // 차트 뷰
            ChartView(
                data: viewModel.chartData,
                chartType: viewModel.selectedChartType
            )
            .frame(height: 200)
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
    }
    
    // MARK: - Status View
    private var statusView: some View {
        HStack {
            Circle()
                .fill(Color.green)
                .frame(width: 8, height: 8)
            
            Text("실시간 연결됨")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text("\(viewModel.chartData.count)개 데이터 포인트")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
    
    // MARK: - Settings View
    private var settingsView: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("대시보드 설정")
                    .font(.title2)
                    .fontWeight(.bold)
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("시간 범위")
                        .font(.headline)
                    
                    Picker("시간 범위", selection: $viewModel.selectedTimeRange) {
                        ForEach(TimeRange.allCases, id: \.self) { range in
                            Text(range.rawValue).tag(range)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("설정")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("완료") {
                        showingSettings = false
                    }
                }
            }
        }
    }
    
    // MARK: - Formatters
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter
    }
}

// MARK: - Metric Card View
struct MetricCardView: View {
    let metric: DashboardMetric
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: metric.icon)
                    .foregroundColor(.blue)
                    .font(.title3)
                
                Spacer()
                
                // 변화율 표시
                HStack(spacing: 4) {
                    Image(systemName: metric.isPositive ? "arrow.up" : "arrow.down")
                        .font(.caption)
                        .foregroundColor(metric.isPositive ? .green : .red)
                    
                    Text("\(abs(metric.change), specifier: "%.1f")%")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(metric.isPositive ? .green : .red)
                }
            }
            
            Text(metric.title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            HStack(alignment: .bottom, spacing: 4) {
                Text("\(metric.value, specifier: "%.0f")")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(metric.unit)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}

// MARK: - Chart View
struct ChartView: View {
    let data: [DataPoint]
    let chartType: ChartType
    
    var body: some View {
        VStack {
            switch chartType {
            case .line:
                LineChartView(data: data)
            case .bar:
                BarChartView(data: data)
            case .area:
                AreaChartView(data: data)
            }
        }
    }
}

// MARK: - Line Chart
struct LineChartView: View {
    let data: [DataPoint]
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                guard !data.isEmpty else { return }
                
                let width = geometry.size.width
                let height = geometry.size.height
                let maxValue = data.map(\.value).max() ?? 1
                let minValue = data.map(\.value).min() ?? 0
                let valueRange = maxValue - minValue
                
                let stepX = width / CGFloat(data.count - 1)
                
                for (index, point) in data.enumerated() {
                    let x = CGFloat(index) * stepX
                    let y = height - ((point.value - minValue) / valueRange) * height
                    
                    if index == 0 {
                        path.move(to: CGPoint(x: x, y: y))
                    } else {
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                }
            }
            .stroke(Color.blue, lineWidth: 2)
            .animation(.easeInOut(duration: 0.5), value: data.count)
        }
    }
}

// MARK: - Bar Chart
struct BarChartView: View {
    let data: [DataPoint]
    
    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .bottom, spacing: 2) {
                ForEach(data) { point in
                    let maxValue = data.map(\.value).max() ?? 1
                    let height = (point.value / maxValue) * geometry.size.height
                    
                    Rectangle()
                        .fill(Color.blue.opacity(0.7))
                        .frame(width: max(2, geometry.size.width / CGFloat(data.count) - 2))
                        .frame(height: height)
                        .animation(.easeInOut(duration: 0.5), value: data.count)
                }
            }
        }
    }
}

// MARK: - Area Chart
struct AreaChartView: View {
    let data: [DataPoint]
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                guard !data.isEmpty else { return }
                
                let width = geometry.size.width
                let height = geometry.size.height
                let maxValue = data.map(\.value).max() ?? 1
                let minValue = data.map(\.value).min() ?? 0
                let valueRange = maxValue - minValue
                
                let stepX = width / CGFloat(data.count - 1)
                
                // 시작점
                let firstPoint = data[0]
                let firstX = CGFloat(0) * stepX
                let firstY = height - ((firstPoint.value - minValue) / valueRange) * height
                path.move(to: CGPoint(x: firstX, y: height))
                path.addLine(to: CGPoint(x: firstX, y: firstY))
                
                // 라인 그리기
                for (index, point) in data.enumerated() {
                    let x = CGFloat(index) * stepX
                    let y = height - ((point.value - minValue) / valueRange) * height
                    path.addLine(to: CGPoint(x: x, y: y))
                }
                
                // 하단으로 닫기
                let lastX = CGFloat(data.count - 1) * stepX
                path.addLine(to: CGPoint(x: lastX, y: height))
                path.closeSubpath()
            }
            .fill(
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.blue.opacity(0.1)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .animation(.easeInOut(duration: 0.5), value: data.count)
        }
    }
}

#Preview {
    DashboardView()
}

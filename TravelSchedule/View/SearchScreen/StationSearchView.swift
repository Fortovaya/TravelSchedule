//
//  StationSearchView.swift
//  TravelSchedule
//
//  Created by Алина on 12.08.2025.
//

import SwiftUI

struct StationSearchView: View {
    // MARK: - Constants
    private enum Constants {
        enum Padding {
            static let horizontal: CGFloat = 16
            static let rowVertical: CGFloat = 4
            static let searchTop: CGFloat = 8
            static let searchBottom: CGFloat = 4
            static let clearHit: CGFloat = 8
            static let clearTrailing: CGFloat = 14
        }
        enum Size {
            static let rowHeight: CGFloat = 60
            static let backButton: CGFloat = 44
        }
        enum CornerRadius {
            static let search: CGFloat = 10
        }
        enum FontSize {
            static let notFound: CGFloat = 24
            static let station: CGFloat = 17
        }
        enum Opacity {
            static let chevronRight: Double = 0.6
        }
        enum Offset {
            static let notFoundTop: CGFloat = 228
        }
        enum ClearButton {
            static let clearIcon = "xmark.circle.fill"
            static let textTrailingInsetForClear: CGFloat = 34
        }
        enum Paging {
            static let pageSize = 12
            static let prefetchThreshold = 5
        }
        static let minSearchCharacters = 2
    }
    
    let city: String
    let onSelect: (String) -> Void
    
    @EnvironmentObject private var app: AppState
    
    // MARK: - State
    @State private var searchText: String = ""
    @State private var allStations: [String] = []
    @State private var isLoading = false
    @State private var currentLoadedCount: Int = Constants.Paging.pageSize
    
    private var filteredStations: [String] {
        let q = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if q.isEmpty {
            return allStations
        } else {
            return allStations.filter { $0.localizedCaseInsensitiveContains(q) }
        }
    }
    
    private var visibleStations: [String] {
        let limit = min(currentLoadedCount, filteredStations.count)
        return Array(filteredStations.prefix(limit))
    }
    
    
    @Environment(\.dismiss) private var dismiss
    
    private let stationService: StationServiceProtocol
    
    init(stationService: StationServiceProtocol, city: String, onSelect: @escaping (String) -> Void) {
        self.stationService = stationService
        self.city = city
        self.onSelect = onSelect
    }
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                searchField
                
                if filteredStations.isEmpty {
                    notFoundView
                } else {
                    stationList
                }
            }
            .navigationTitle("Выбор станции")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(false)
            .toolbarRole(.editor)
            .task {
                await loadStations()
            }
            .onChange(of: searchText) {
                currentLoadedCount = min(Constants.Paging.pageSize, filteredStations.count)
            }
        }
        .tint(.ypBlack)
    }
    
    private var searchField: some View {
        SearchTextField(text: $searchText, placeholder: "Введите запрос")
            .padding(.horizontal, Constants.Padding.horizontal)
            .padding(.top, Constants.Padding.searchTop)
            .padding(.bottom, Constants.Padding.searchBottom)
    }
    
    private var stationList: some View {
        List(filteredStations, id: \.self) { station in
            HStack {
                Text(station)
                    .font(.system(size: Constants.FontSize.station, weight: .regular))
                    .foregroundColor(.ypBlack)
                Spacer()
                Image(systemName: "chevron.right").foregroundColor(.ypBlack)
            }
            .frame(height: Constants.Size.rowHeight)
            .contentShape(Rectangle())
            .onTapGesture {
                onSelect(station)
                dismiss()
            }
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
        }
        .listStyle(.plain)
    }
    
    private var notFoundView: some View {
        VStack {
            Spacer().frame(height: Constants.Offset.notFoundTop)
            Text("Станция не найдена")
                .font(.system(size: Constants.FontSize.notFound, weight: .bold))
                .foregroundColor(.ypBlack)
            Spacer()
        }
    }
    
    private func loadStations() async {
        isLoading = true
        loadWithGlobalError(
            app: app,
            task: {
                let stations = try await stationService.getStations(for: self.city)
                return stations.compactMap { $0.title }
            },
            onSuccess: { stationTitles in
                self.allStations = stationTitles
                self.currentLoadedCount = min(Constants.Paging.pageSize, stationTitles.count)
                self.isLoading = false
            }
        )
    }
    
    private func loadMoreIfNeeded(currentItem: String) {
        guard !filteredStations.isEmpty else { return }
        guard currentLoadedCount < filteredStations.count else { return }
        
        if let index = visibleStations.firstIndex(of: currentItem),
           index >= visibleStations.count - Constants.Paging.prefetchThreshold {
            currentLoadedCount = min(
                currentLoadedCount + Constants.Paging.pageSize,
                filteredStations.count
            )
        }
    }
}

#Preview("Москва - основные станции") {
    NavigationStack {
        StationSearchView(
            stationService: MockStationService(),
            city: "Москва"
        ) { station in
            print("Выбрана станция: \(station)")
        }
    }
    .environmentObject(AppState())
}

#Preview("Санкт-Петербург - основные станции") {
    NavigationStack {
        StationSearchView(
            stationService: MockStationService(),
            city: "Санкт-Петербург"
        ) { station in
            print("Выбрана станция: \(station)")
        }
    }
    .environmentObject(AppState())
}

#Preview("Пустой список станций") {
    struct EmptyStationService: StationServiceProtocol {
        func getStations(for city: String) async throws -> [Station] {
            try await Task.sleep(nanoseconds: 1_000_000_000)
            return []
        }
    }
    
    return NavigationStack {
        StationSearchView(
            stationService: EmptyStationService(),
            city: "Неизвестный город"
        ) { station in
            print("Выбрана станция: \(station)")
        }
    }
    .environmentObject(AppState())
}

#Preview("StationSearchView + Загрузка") {
    struct SlowStationService: StationServiceProtocol {
        func getStations(for city: String) async throws -> [Station] {
            try await Task.sleep(nanoseconds: 3_000_000_000)
            return [
                Station(title: "Тестовая станция 1", codes: nil),
                Station(title: "Тестовая станция 2", codes: nil)
            ]
        }
    }
    
    return NavigationStack {
        StationSearchView(
            stationService: SlowStationService(),
            city: "Тестовый город"
        ) { station in
            print("Выбрана станция: \(station)")
        }
    }
    .environmentObject(AppState())
}

#Preview("StationSearchView + Поиск") {
    NavigationStack {
        StationSearchView(
            stationService: MockStationService(),
            city: "Москва"
        ) { station in
            print("Выбрана станция: \(station)")
        }
    }
    .environmentObject(AppState())
}

#Preview("StationSearchView + Error internet") {
    struct Harness: View {
        @StateObject var app = AppState()
        var body: some View {
            NavigationStack {
                StationSearchView(
                    stationService: MockStationService(),
                    city: "Москва"
                ) { _ in }
            }
            .environmentObject(app)
            .withGlobalErrors(app)
            .onAppear { app.showError(.offline) }
        }
    }
    return Harness()
}

#Preview("StationSearchView + Error server") {
    struct Harness: View {
        @StateObject var app = AppState()
        var body: some View {
            NavigationStack {
                StationSearchView(
                    stationService: MockStationService(),
                    city: "Москва"
                ) { _ in }
            }
            .environmentObject(app)
            .withGlobalErrors(app)
            .onAppear { app.showError(.server) }
        }
    }
    return Harness()
}

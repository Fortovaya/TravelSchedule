//
//  CitySearchView.swift
//  TravelSchedule
//
//  Created by Алина on 12.08.2025.
//

import SwiftUI

struct CitySearchView: View {
    
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
            static let city: CGFloat = 17
        }
        enum Opacity {
            static let chevronRight: Double = 0.6
        }
        enum Offset {
            static let notFoundTop: CGFloat = 228
        }
        enum ClearIcon {
            static let name = "xmark.circle.fill"
            static let textTrailingInset: CGFloat = 34
        }
        enum Paging {
            static let pageSize = 20
            static let prefetchThreshold = 5
        }
        static let minSearchCharacters = 3
    }
    
    // MARK: - Dependencies
    let onSelect: (String) -> Void
    @EnvironmentObject private var app: AppState
    
    // MARK: - State
    @State private var searchText: String = ""
    @State private var selectedCity: String? = nil
    @State private var showStations = false
    @State private var allCities: [String] = []
    @State private var isLoading = false
    @State private var currentLoadedCount: Int = Constants.Paging.pageSize
    
    private var isSearching: Bool {
        searchText.trimmingCharacters(in: .whitespacesAndNewlines).count >= Constants.minSearchCharacters
    }
    
    private var filteredCities: [String] {
        let q = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !q.isEmpty else { return allCities }
        guard q.count >= Constants.minSearchCharacters else { return [] }
        return allCities.filter { $0.localizedCaseInsensitiveContains(q) }
    }
    
    private var visibleCities: [String] {
        let source = filteredCities
        let limit = min(currentLoadedCount, source.count)
        return Array(source.prefix(limit))
    }
    
    private var shouldShowPlaceholder: Bool {
        let q = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        return q.isEmpty
    }
    
    private var shouldShowSearchResults: Bool {
        let q = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        return q.count >= Constants.minSearchCharacters
    }
    
    private var shouldShowResults: Bool {
        searchText.count >= Constants.minSearchCharacters
    }
    
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Services
    private let cityService: any CityServiceProtocol
    
    // MARK: - Init
    init(cityService: some CityServiceProtocol, onSelect: @escaping (String) -> Void) {
        self.cityService = cityService
        self.onSelect = onSelect
    }
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                searchField
                
                if isSearching && visibleCities.isEmpty {
                    notFoundView
                } else if visibleCities.isEmpty {
                    if isLoading {
                        Spacer()
                    } else {
                        Spacer()
                    }
                } else {
                    cityList
                }
            }
            .navigationTitle("Выбор города")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarRole(.editor)
            .navigationDestination(isPresented: $showStations) {
                if let city = selectedCity,
                   let stationService = try? APIFactory.makeStationService() {
                    StationSearchView(
                        stationService: stationService,
                        city: city
                    ) { station in
                        onSelect("\(city) (\(station))")
                        dismiss()
                    }
                } else {
                    ErrorStateView(state: .server)
                        .task { app.showError(.server) }
                }
            }
            .task {
                await loadCities()
            }
            .onChange(of: searchText) {
                currentLoadedCount = min(Constants.Paging.pageSize, filteredCities.count)
            }
        }
    }
    
    // MARK: - Subviews
    private var searchField: some View {
        SearchTextField(text: $searchText, placeholder: "Введите запрос")
            .padding(.horizontal, Constants.Padding.horizontal)
            .padding(.top, Constants.Padding.searchTop)
            .padding(.bottom, Constants.Padding.searchBottom)
    }
    
    private var cityList: some View {
        List(filteredCities, id: \.self) { city in
            HStack {
                Text(city)
                    .font(.system(size: Constants.FontSize.city, weight: .regular))
                    .foregroundColor(.ypBlack)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.ypBlack)
            }
            .frame(height: Constants.Size.rowHeight)
            .contentShape(Rectangle())
            .onTapGesture {
                selectedCity = city
                showStations = true
            }
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
        }
        .listStyle(.plain)
    }
    
    private var notFoundView: some View {
        VStack {
            Spacer().frame(height: Constants.Offset.notFoundTop)
            Text("Город не найден")
                .font(.system(size: Constants.FontSize.notFound, weight: .bold))
                .foregroundColor(.ypBlack)
            Spacer()
        }
    }
    
    // MARK: - Loading
    private func loadCities() async {
        isLoading = true
        loadWithGlobalError(
            app: app,
            task: {
                let cities = try await cityService.getAllCities()
                return cities.compactMap { $0.title }
            },
            onSuccess: { (cityTitles: [String]) in
                var seen = Set<String>()
                self.allCities = cityTitles
                    .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                    .filter { !$0.isEmpty }
                    .filter { seen.insert($0).inserted }
                    .sorted {
                        $0.compare(
                            $1,
                            options: .caseInsensitive,
                            range: nil,
                            locale: Locale(identifier: "ru_RU")
                        ) == .orderedAscending
                    }
                self.currentLoadedCount = min(Constants.Paging.pageSize, self.allCities.count)
                self.isLoading = false
            }
        )
    }
}



#Preview {
    CitySearchView(
        cityService: MockCityService(),
        onSelect: { _ in }
    )
    .environmentObject(AppState())
}

#Preview("CitySearchView + Error internet") {
    struct Harness: View {
        @StateObject var app = AppState()
        var body: some View {
            CitySearchView(
                cityService: MockCityService(),
                onSelect: { _ in }
            )
            .environmentObject(app)
            .withGlobalErrors(app)
            .onAppear { app.showError(.offline) }
        }
    }
    return Harness()
}

#Preview("CitySearchView + Error server") {
    struct Harness: View {
        @StateObject var app = AppState()
        var body: some View {
            CitySearchView(
                cityService: MockCityService(),
                onSelect: { _ in }
            )
            .environmentObject(app)
            .withGlobalErrors(app)
            .onAppear { app.showError(.server) }
        }
    }
    return Harness()
}

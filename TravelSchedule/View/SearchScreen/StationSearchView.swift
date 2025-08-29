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
    let onSelect: (StationLite) -> Void
    
    @EnvironmentObject private var app: AppState
    
    // MARK: - State
    @State private var searchText: String = ""
    @State private var allStations: [StationLite] = []
    @State private var isLoading = false
    @State private var currentLoadedCount: Int = Constants.Paging.pageSize
    
    private var filteredStations: [StationLite] {
        let q = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !q.isEmpty else { return allStations }
        return allStations.filter { $0.title.localizedCaseInsensitiveContains(q) }
    }
    
    private var visibleStations: [StationLite] {
        let limit = min(currentLoadedCount, filteredStations.count)
        return Array(filteredStations.prefix(limit))
    }
    
    @Environment(\.dismiss) private var dismiss
    
    private let stationService: any StationServiceProtocol
    
    init(stationService: some StationServiceProtocol, city: String, onSelect: @escaping (StationLite) -> Void) {
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
                Text(station.title)
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
                let raw = try await stationService.getStations(for: self.city)
                return raw.compactMap { s -> StationLite? in
                    guard let title = s.title else { return nil }
                    let code = s.code ?? s.codes?.yandex_code
                    guard let code else { return nil }
                    return StationLite(title: title, code: code)
                }
            },
            onSuccess: { (result: [StationLite]) in
                self.allStations = result
                self.currentLoadedCount = min(Constants.Paging.pageSize, result.count)
                self.isLoading = false
            }
        )
    }
    
    private func loadMoreIfNeeded(currentItem: StationLite) {
        guard !filteredStations.isEmpty else { return }
        guard currentLoadedCount < filteredStations.count else { return }
        
        if let index = visibleStations.firstIndex(where: { $0.id == currentItem.id }),
           index >= visibleStations.count - Constants.Paging.prefetchThreshold {
            currentLoadedCount = min(
                currentLoadedCount + Constants.Paging.pageSize,
                filteredStations.count
            )
        }
    }
}

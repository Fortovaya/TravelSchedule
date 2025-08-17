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
        static let horizontalPadding: CGFloat = 16
        static let searchCorner: CGFloat = 10
        static let rowHeight: CGFloat = 60
        static let rowVerticalPadding: CGFloat = 4
        static let searchTopPadding: CGFloat = 8
        static let searchBottomPadding: CGFloat = 4
        static let notFoundFont: CGFloat = 24
        static let backButtonSize: CGFloat = 44
        static let chevronRightOpacity: Double = 0.6
        static let cityFontSize: CGFloat = 17
        static let notFoundTopOffset: CGFloat = 228
        static let clearIcon = "xmark.circle.fill"
        static let clearHitPadding: CGFloat = 8
        static let clearTrailingPadding: CGFloat = 14
        static let textTrailingInsetForClear: CGFloat = 34
    }
    // MARK: - Props
    let onSelect: (String) -> Void
    
    @EnvironmentObject private var app: AppState
    
    // MARK: - State
    @State private var searchText: String = ""
    @State private var selectedCity: String? = nil
    @State private var showStations = false
    
    // MARK: - Data (пока мок)
    private let cities = [
        "Москва", "Санкт Петербург", "Сочи",
        "Горный воздух", "Краснодар", "Казань", "Омск"
    ]
    
    private var filteredCities: [String] {
        let q = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        return q.isEmpty ? cities : cities.filter { $0.localizedCaseInsensitiveContains(q) }
    }
    
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                searchField
                
                if filteredCities.isEmpty {
                    notFoundView
                } else {
                    cityList
                }
            }
            .navigationTitle("Выбор города")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarRole(.editor)
            .navigationDestination(isPresented: $showStations) {
                StationSearchView(city: selectedCity ?? "") { station in
                    if let city = selectedCity {
                        onSelect("\(city) (\(station))")
                    }
                    dismiss()
                }
            }
        }
    }
    
    // MARK: - Elements
//    private var searchField: some View {
//        HStack {
//            Image(systemName: "magnifyingglass").foregroundColor(.gray)
//            TextField("Введите запрос", text: $searchText)
//                .foregroundColor(.primary)
//                .disableAutocorrection(true)
//                .textInputAutocapitalization(.never)
//                .padding(.trailing, Constants.textTrailingInsetForClear)
//        }
//        .padding(10)
//        .background(Color.gray.opacity(0.15))
//        .cornerRadius(Constants.searchCorner)
//        .padding(.horizontal, Constants.horizontalPadding)
//        .padding(.top, Constants.searchTopPadding)
//        .padding(.bottom, Constants.searchBottomPadding)
//        .overlay(alignment: .trailing) {
//            if !searchText.isEmpty {
//                Button {
//                    withAnimation(.default) { searchText = "" }
//                } label: {
//                    Image(systemName: Constants.clearIcon)
//                        .foregroundColor(.secondary)
//                        .imageScale(.medium)
//                        .padding(Constants.clearHitPadding)
//                }
//                .padding(.trailing, Constants.clearTrailingPadding)
//                .accessibilityLabel("Очистить")
//            }
//        }
//    }
    
    private var searchField: some View {
        SearchTextField(text: $searchText, placeholder: "Введите запрос")
            .padding(.horizontal, Constants.horizontalPadding)
            .padding(.top, Constants.searchTopPadding)
            .padding(.bottom, Constants.searchBottomPadding)
    }
    
    private var cityList: some View {
        List(filteredCities, id: \.self) { city in
            HStack {
                Text(city)
                    .font(.system(size: Constants.cityFontSize, weight: .regular))
                    .foregroundColor(.ypBlack)
                Spacer()
                Image(systemName: "chevron.right").foregroundColor(.ypBlack)
            }
            .frame(height: Constants.rowHeight)
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
            Spacer().frame(height: Constants.notFoundTopOffset)
            Text("Город не найден")
                .font(.system(size: Constants.notFoundFont, weight: .bold))
                .foregroundColor(.ypBlack)
            Spacer()
        }
    }
}

#Preview {
    CitySearchView { _ in }
}

#Preview("CitySearchView + Error internet") {
    struct Harness: View {
        @StateObject var app = AppState()
        var body: some View {
            CitySearchView { _ in }
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
            CitySearchView { _ in }
                .environmentObject(app)
                .withGlobalErrors(app)
                .onAppear { app.showError(.server) }
        }
    }
    return Harness()
}

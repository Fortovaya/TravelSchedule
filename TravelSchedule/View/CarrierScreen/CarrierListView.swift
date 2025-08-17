//
//  CarrierListView.swift
//  TravelSchedule
//
//  Created by Алина on 16.08.2025.
//

import SwiftUI

struct CarrierListView: View {
    
    private enum Constants {
        static let viewSpacing: CGFloat = 12
        static let horizontalPadding: CGFloat = 16
        static let titleTopPadding: CGFloat = 12
        static let titleFontSize: CGFloat = 24
        static let rowVerticalInset: CGFloat = 8
        static let rowHorizontalInset: CGFloat = 16
        static let listBottomPadding: CGFloat = 10
        static let bottomButtonFontSize: CGFloat = 17
        static let bottomButtonHeight: CGFloat = 60
        static let bottomButtonCorner: CGFloat = 16
        static let bottomPadding: CGFloat = 24
        static let retryDelay: TimeInterval = 10
        static let maxRetries: Int = 3
        static let mockDelayNs: UInt64 = 400_000_000
    }
    
    let headerFrom: String
    let headerTo: String
    var items: [CarrierRowViewModel] = CarrierRowViewModel.mock
    
    let searchService: SearchServiceProtocol
    let carrierService: CarrierServiceProtocol
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var app: AppState
    
    @State private var showFilters = false
    @State private var loadedItems: [CarrierRowViewModel] = []
    @State private var isLoading = true
    
    var body: some View {
        
        ZStack {
            Color(.systemBackground).ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: Constants.viewSpacing) {
                Text("\(headerFrom) → \(headerTo)")
                    .font(.system(size: Constants.titleFontSize, weight: .bold))
                    .foregroundColor(.ypBlack)
                    .padding(.horizontal, Constants.horizontalPadding)
                    .padding(.top, Constants.titleTopPadding)
                
                if isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    listView
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.ypBlack)
                }
            }
        }
        .toolbarBackground(Color(.systemBackground), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        
        .safeAreaInset(edge: .bottom) {
            HStack {
                Button("Уточнить время") {
                    showFilters = true
                }
                .font(.system(size: Constants.bottomButtonFontSize, weight: .bold))
                .frame(maxWidth: .infinity, minHeight: Constants.bottomButtonHeight)
                .background(Color.ypBlue)
                .foregroundColor(.ypWhiteUniversal)
                .cornerRadius(Constants.bottomButtonCorner)
            }
            .padding(.horizontal, Constants.horizontalPadding)
            .padding(.bottom, Constants.bottomPadding)
            .background(Color(.systemBackground))
        }
        .navigationDestination(isPresented: $showFilters) {
            ScheduleFilterView { selectedParts, transfers in
            }
        }
        .onAppear { load() }
    }
    
    @ViewBuilder
    private var listView: some View {
        List(loadedItems) { item in
            CarrierTableRow(viewModel: item)
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
                .listRowInsets(.init(top: Constants.rowVerticalInset,
                                     leading: Constants.rowHorizontalInset,
                                     bottom: Constants.rowVerticalInset,
                                     trailing: Constants.rowHorizontalInset))
        }
        .listStyle(.plain)
        .scrollIndicators(.hidden)
        .scrollContentBackground(.hidden)
        
        .contentMargins(.bottom, Constants.listBottomPadding,
                        for: .scrollContent)
    }
    
    private func load() {
        isLoading = true
        loadWithGlobalError(app: app,
                            delay: Constants.retryDelay,
                            maxRetries: Constants.maxRetries,
                            task: { try await fetchCarriers()},
                            onSuccess: { data in
            loadedItems = data
            isLoading = false
        }
        )
    }
    
    private func fetchCarriers() async throws -> [CarrierRowViewModel] {
        try await Task.sleep(nanoseconds: Constants.mockDelayNs)
        return items
    }
}

#Preview {
    NavigationStack {
        CarrierListView(
            headerFrom: "c146",
            headerTo: "c213",
            searchService: try! APIFactory.makeSearchService(),
            carrierService: try! APIFactory.makeCarrierService()
        )
        .environmentObject(AppState())
    }
}

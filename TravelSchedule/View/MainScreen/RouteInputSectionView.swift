//
//  RouteInputSectionView.swift
//  TravelSchedule
//
//  Created by Алина on 29.07.2025.
//

import SwiftUI

struct RouteInputSectionView: View {
    
    private enum Constants {
        static let horizontalPadding: CGFloat = 16.0
        static let verticalPadding: CGFloat = 16.0
        static let leftPadding: CGFloat = 20.0
        static let viewHeight: CGFloat = 128.0
        static let viewSpacing: CGFloat = 12.0
        static let fieldSpacing: CGFloat = 8.0
        static let labelSize: CGFloat = 17.0
        static let labelButtonFontSize: CGFloat = 17
        static let buttonSize: CGFloat = 36.0
        static let colorTextField: Color = .ypGray
        static let colorButton: Color = .ypWhiteUniversal
        static let cardBackground: Color = .ypWhiteUniversal
        static let primaryButtonBackground: Color = .ypBlue
        static let cornerRadiusView: Double = 20.0
        static let searchButtonCornerRadius: CGFloat = 16.0
        static let animationDuration: Double = 0.2
        static let swapSpringResponse: Double = 0.25
        static let swapSpringDamping: Double = 0.9
        static let placeholderFrom = "Откуда"
        static let placeholderTo   = "Куда"
        static let searchButtonTitle = "Найти"
        static let squarepathSystemImage = "arrow.2.squarepath"
        static let searchButtonWidth: CGFloat = 150.0
        static let searchButtonHeight: CGFloat = 60.0
        
    }
    
    @State private var from: String = ""
    @State private var to: String = ""
    @State private var isShowingFromSearch = false
    @State private var isShowingToSearch = false
    @State private var showCarriers = false
    @EnvironmentObject private var app: AppState
    
    let actionButton: () -> Void
    let actionSearchButton: (_ from: String, _ to: String) -> Void
    
    
    private var hasBothInputs: Bool {
        !from.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !to.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        VStack(spacing: Constants.viewSpacing) {
            ZStack {
                Color.ypBlue.cornerRadius(Constants.cornerRadiusView)
                HStack {
                    searchCityField
                    squarepathButton
                }
                .padding(.horizontal, Constants.horizontalPadding)
                .padding(.vertical, Constants.verticalPadding)
            }
            .frame(height: Constants.viewHeight)
            .padding(.horizontal, Constants.horizontalPadding)
            if hasBothInputs { searchButton.transition(.opacity.combined(with: .scale)) }
        }
        .animation(.easeInOut(duration: Constants.animationDuration), value: hasBothInputs)
        .fullScreenCover(isPresented: $isShowingFromSearch) {
            CitySearchView { city in
                from = city
                isShowingFromSearch = false
            }
        }
        .fullScreenCover(isPresented: $isShowingToSearch) {
            CitySearchView { city in
                to = city
                isShowingToSearch = false
            }
        }
        .navigationDestination(isPresented: $showCarriers) {
            if let search = try? APIFactory.makeSearchService(),
               let carrier = try? APIFactory.makeCarrierService() {
                CarrierListView(
                    headerFrom: from,
                    headerTo: to,
                    searchService: search,
                    carrierService: carrier
                )
            } else {
                ErrorStateView(state: .server)
                    .task { app.showError(.server) }
            }
        }
    }
    
    private var searchCityField: some View {
        ZStack {
            HStack {
                VStack(alignment: .leading, spacing: Constants.fieldSpacing) {
                    Button(action: {
                        isShowingFromSearch = true
                    }) {
                        HStack {
                            Text(from.isEmpty ? Constants.placeholderFrom : from)
                                .foregroundColor(from.isEmpty ? Constants.colorTextField : .ypBlackUniversal)
                                .font(.system(size: Constants.labelSize, weight: .regular))
                            Spacer()
                        }
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    
                    Spacer().frame(height: 14)
                    
                    Button(action: {
                        isShowingToSearch = true
                    }) {
                        HStack {
                            Text(to.isEmpty ? Constants.placeholderTo : to)
                                .foregroundColor(from.isEmpty ? Constants.colorTextField : .ypBlackUniversal)
                                .font(.system(size: Constants.labelSize, weight: .regular))
                            Spacer()
                        }
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
                .padding(.vertical, Constants.verticalPadding)
                .padding(.horizontal, Constants.leftPadding)
                .background(Color.ypWhiteUniversal)
                .cornerRadius(Constants.cornerRadiusView)
                .frame(height: 96)
            }
        }
    }
    
    private var squarepathButton: some View {
        let isDisabled = from.isEmpty && to.isEmpty
        
        return Button {
            withAnimation(.spring(response: Constants.swapSpringResponse,
                                  dampingFraction: Constants.swapSpringDamping)) {
                swap(&from, &to)
            }
            actionButton()
        } label: {
            Image(systemName: Constants.squarepathSystemImage)
                .foregroundColor(.ypBlue)
                .frame(width: Constants.buttonSize, height: Constants.buttonSize)
        }
        .background(Constants.colorButton)
        .clipShape(Circle())
        .disabled(isDisabled)
    }
    
    private var searchButton: some View {
        Button(action: {
            actionSearchButton(from, to)
            showCarriers = true
        }) {
            Text(Constants.searchButtonTitle)
                .font(.system(size: Constants.labelButtonFontSize, weight: .bold))
                .foregroundColor(.ypWhiteUniversal)
                .frame(width: Constants.searchButtonWidth, height: Constants.searchButtonHeight)
                .background(Constants.primaryButtonBackground)
                .cornerRadius(Constants.searchButtonCornerRadius)
        }
        .buttonStyle(.plain)
        .disabled(!hasBothInputs)
    }
}

#Preview {
    RouteInputSectionView(actionButton: {}, actionSearchButton: {from,to in })
}

//
//  MainTabView.swift
//  TravelSchedule
//
//  Created by Алина on 01.08.2025.
//

import SwiftUI

enum Route: Hashable {
    case carriers(from: String, to: String)
}

struct MainTabView: View {
    
    private enum Constants {
        static let tabIconSize: CGFloat = 30
        static let firstTabSystemImage = "arrow.up.message.fill"
        static let secondTabAssetImage = "Vector"
    }
    
    @EnvironmentObject private var app: AppState
    @State private var path: [Route] = []
    
    private var isTabBarHidden: Bool {
        if let last = path.last, case .carriers = last { return true }
        return false
    }
    
    var body: some View {
        TabView {
            
            NavigationStack {
                RouteInputSectionView(
                    actionButton: {},
                    actionSearchButton: { from, to in
                        path.append(Route.carriers(from: from, to: to))
                    }
                )
                .navigationDestination(for: Route.self) { route in
                    switch route {
                        case let .carriers(from, to):
                            if let search = try? APIFactory.makeSearchService(),
                               let carrier = try? APIFactory.makeCarrierService() {
                                CarrierListView(headerFrom: from,
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
            }
            .toolbar(isTabBarHidden ? .hidden : .visible, for: .tabBar)
            .tabItem {
                Image(systemName: Constants.firstTabSystemImage)
                    .renderingMode(.template)
                    .frame(width: Constants.tabIconSize, height: Constants.tabIconSize)
            }
            
            SettingsView()
                .tabItem {
                    Image(Constants.secondTabAssetImage)
                        .renderingMode(.template)
                        .frame(width: Constants.tabIconSize, height: Constants.tabIconSize)
                }
        }
        .tint(.ypBlack)
        .accentColor(.ypGray)
        .withGlobalErrors(app)
    }
}

#Preview {
    MainTabView()
        .environmentObject(AppState())
}

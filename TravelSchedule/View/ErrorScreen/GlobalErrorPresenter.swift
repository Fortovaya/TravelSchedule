//
//  GlobalErrorPresenter.swift
//  TravelSchedule
//
//  Created by Алина on 17.08.2025.
//

import SwiftUI

struct GlobalErrorPresenter: ViewModifier {
    @ObservedObject var app: AppState
    
    func body(content: Content) -> some View {
        content
            .overlay(
                ZStack {
                    if let state = app.errorState {
                        ErrorStateView(state: state)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color(.systemBackground))
                            .edgesIgnoringSafeArea(.all)
                    }
                }
            )
    }
}

extension View {
    func withGlobalErrors(_ app: AppState) -> some View {
        self.modifier(GlobalErrorPresenter(app: app))
    }
}

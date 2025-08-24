//
//  ContentView.swift
//  TravelSchedule
//
//  Created by Алина on 06.07.2025.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var app: AppState
    @Environment(\.colorScheme) private var colorScheme
    
    @AppStorage("isDarkThemeEnabled") private var isDarkThemeEnabled = false
    @AppStorage("didBootstrapTheme") private var didBootstrapTheme = false
    
    private var resolvedScheme: ColorScheme? {
        didBootstrapTheme ? (isDarkThemeEnabled ? .dark : .light) : colorScheme
    }
    
    var body: some View {
        MainTabView()
            .preferredColorScheme(isDarkThemeEnabled ? .dark : nil)
            .edgesIgnoringSafeArea(.bottom)
            .task {
                /// Одноразовая инициализация по системной теме
                if !didBootstrapTheme {
                    isDarkThemeEnabled = (colorScheme == .dark)
                    didBootstrapTheme = true
                }
            }
    }
}

#Preview { ContentView().environmentObject(AppState()) }

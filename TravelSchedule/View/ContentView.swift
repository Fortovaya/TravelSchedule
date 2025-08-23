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
    
    var body: some View {
        MainTabView()
            .edgesIgnoringSafeArea(.bottom)
    }
}

#Preview { ContentView().environmentObject(AppState()) }

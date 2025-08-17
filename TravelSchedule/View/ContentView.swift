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
        GeometryReader { geo in
            ZStack(alignment: .bottom) {
                MainTabView()
                
                if colorScheme == .light {
                    Rectangle()
                        .fill(Color.ypGray)
                        .frame(height: 0.5)
                        .padding(.bottom, geo.safeAreaInsets.bottom + 48)
                        .ignoresSafeArea()
                }
            }
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}

#Preview {
    ContentView()
}

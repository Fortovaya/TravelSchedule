//
//  TravelScheduleApp.swift
//  TravelSchedule
//
//  Created by Алина on 06.07.2025.
//

import SwiftUI

@main
struct TravelScheduleApp: App {
    @StateObject private var app = AppState()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(app)
                .withGlobalErrors(app)
        }
    }
}

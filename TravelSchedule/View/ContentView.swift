//
//  ContentView.swift
//  TravelSchedule
//
//  Created by Алина on 06.07.2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
                TestAPI.testFetchStations()
                TestAPI.testFetchCarrier()
                TestAPI.testFetchCopyright()
                TestAPI.testFetchNearestSettlement()
                TestAPI.testFetchSearch()
                TestAPI.testFetchStationSchedule()
                TestAPI.testFetchStationsList()
                TestAPI.testFetchThread()
        }
    }
}

#Preview {
    ContentView()
}

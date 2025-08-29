//
//  FilterResultViewModel.swift
//  TravelSchedule
//
//  Created by Алина on 29.08.2025.
//

import Foundation
import Observation

@MainActor
@Observable
final class FilterResultViewModel {
    let headerFrom: String
    let headerTo: String
    let items: [CarrierRowViewModel]
    
    init(headerFrom: String, headerTo: String, items: [CarrierRowViewModel]) {
        self.headerFrom = headerFrom
        self.headerTo = headerTo
        self.items = items
    }
}

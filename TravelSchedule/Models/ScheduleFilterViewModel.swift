//
//  ScheduleFilterViewModel.swift
//  TravelSchedule
//
//  Created by Алина on 29.08.2025.
//

import Foundation
import Observation

@MainActor
@Observable
final class ScheduleFilterViewModel {
    var selectedParts: Set<DayPart> = []
    var transfers: TransfersOption? = nil
}

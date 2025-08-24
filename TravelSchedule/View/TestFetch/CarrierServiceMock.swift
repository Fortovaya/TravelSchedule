//
//  CarrierServiceMock.swift
//  TravelSchedule
//
//  Created by Алина on 24.08.2025.
//

#if DEBUG
import Foundation

struct CarrierServiceMock: CarrierServiceProtocol {
    var delay: UInt64 = 300_000_000 // 0.3 c
    
    func getCarrierInfo(code: String) async throws -> CarrierResponse {
        try await Task.sleep(nanoseconds: delay)
        return .mock
    }
}
#endif

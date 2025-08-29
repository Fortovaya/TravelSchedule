//
//  CarrierInfoViewModel.swift
//  TravelSchedule
//
//  Created by Алина on 24.08.2025.
//

import SwiftUI

@MainActor
final class CarrierInfoViewModel: ObservableObject {
    enum State { case idle, loading, loaded(CarrierResponse), failed(Error) }
    
    @Published private(set) var state: State = .idle
    
    private let code: String
    private let service: CarrierServiceProtocol
    
    init(code: String, service: CarrierServiceProtocol) {
        self.code = code
        self.service = service
    }
    
    func load() {
        guard case .idle = state else { return }
        state = .loading
        Task {
            do {
                let resp = try await service.getCarrierInfo(code: code)
                state = .loaded(resp)
            } catch {
                state = .failed(error)
            }
        }
    }
    
    func retry() {
        state = .idle
        load()
    }
}

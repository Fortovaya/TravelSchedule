//
//  CarrierService.swift
//  TravelSchedule
//
//  Created by Алина on 21.07.2025.
//

import OpenAPIRuntime
import Foundation

typealias CarrierResponse = Components.Schemas.CarrierResponse

protocol CarrierServiceProtocol: Actor, Sendable {
    /// информация о перевозчике по указанному коду перевозчика
    func getCarrierInfo(code: String) async throws -> CarrierResponse
}

final actor CarrierService: CarrierServiceProtocol {
    
    private let client: Client
    private let apikey: String
    
    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }
    
    func getCarrierInfo(code: String) async throws -> CarrierResponse {
        let response = try await client.getCarrierInfo(query: .init(apikey: apikey, code: code))
        return try response.ok.body.json
    }
    
    func debugCarrierStructure(_ response: CarrierResponse) {
        dump(response)
    }
}

//
//  NearestSettlementService.swift
//  TravelSchedule
//
//  Created by Алина on 21.07.2025.
//

import OpenAPIRuntime

typealias NearestCityResponse = Components.Schemas.NearestCityResponse

protocol NearestSettlementServiceProtocol: Actor {
    /// информация о ближайшем к указанной точке городе
    func getNearestCity(lat: Double, lng: Double) async throws -> NearestCityResponse
}

final actor NearestSettlementService: NearestSettlementServiceProtocol {
    
    private let client: Client
    private let apikey: String
    
    init(client: Client, apikey: String){
        self.client = client
        self.apikey = apikey
    }
    
    func getNearestCity(lat: Double, lng: Double) async throws -> NearestCityResponse {
        let response = try await client.getNearestCity(query: .init(apikey: apikey,
                                                                    lat: lat,
                                                                    lng: lng))
        return try response.ok.body.json
    }
    
}

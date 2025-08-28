//
//  StationsListService.swift
//  TravelSchedule
//
//  Created by Алина on 21.07.2025.
//

import OpenAPIRuntime
import Foundation

typealias AllStationsResponse = Components.Schemas.AllStationsResponse

protocol StationsListServiceProtocol: Actor {
    /// полный список станций, информацию о которых предоставляют Яндекс Расписания
    func getAllStations() async throws -> AllStationsResponse
}

final actor StationsListService: StationsListServiceProtocol {
    
    private let client: Client
    private let apikey: String
    private let decoder = JSONDecoder()
    
    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }
    
    func getAllStations() async throws -> AllStationsResponse {
        let response = try await client.getAllStations(query: .init(apikey: apikey))
        
        let responseBody = try response.ok.body.html
        
        let limit = 50 * 1024 * 1024 // 50Mb

        let fullData = try await Data(collecting: responseBody, upTo: limit)
        
        let allStations = try JSONDecoder().decode(AllStationsResponse.self, from: fullData)
        
        return allStations
    }
}

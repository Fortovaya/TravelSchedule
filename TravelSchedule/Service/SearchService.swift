//
//  SearchService.swift
//  TravelSchedule
//
//  Created by Алина on 21.07.2025.
//

import OpenAPIRuntime
import Foundation

typealias SearchResponse = Components.Schemas.Segments

protocol SearchServiceProtocol: Actor, Sendable {
    /// список рейсов, следующих от указанной станции отправления к указанной станции прибытия и информацию по каждому рейсу
    func getScheduleBetweenStations(from: String, to: String) async throws -> SearchResponse
}

final actor SearchService: SearchServiceProtocol {
    private let client: Client
    private let apikey: String
    
    init(client: Client, apikey: String){
        self.client = client
        self.apikey = apikey
    }
    
    func getScheduleBetweenStations(from: String, to: String) async throws -> SearchResponse {
        let response = try await client.getScheduleBetweenStations(
            query: .init(
                apikey: apikey,
                from: from,
                to: to,
                date: Date().toISODateString(),
                transfers: true
            )
        )
        return try response.ok.body.json
    }
}

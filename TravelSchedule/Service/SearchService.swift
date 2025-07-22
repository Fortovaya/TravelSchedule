//
//  SearchService.swift
//  TravelSchedule
//
//  Created by Алина on 21.07.2025.
//

import OpenAPIRuntime

typealias SearchResponse = Components.Schemas.Segments

protocol SearchServiceProtocol {
    /// список рейсов, следующих от указанной станции отправления к указанной станции прибытия и информацию по каждому рейсу
    func getScheduleBetweenStations(from: String, to: String) async throws -> SearchResponse
}

final class SearchService: SearchServiceProtocol {
    private let client: Client
    private let apikey: String
    
    init(client: Client, apikey: String){
        self.client = client
        self.apikey = apikey
    }
    
    func getScheduleBetweenStations(from: String, to: String) async throws -> SearchResponse {
        let response = try await client.getScheduleBetweenStations(query: .init(apikey: apikey, from: from, to: to))
        return try response.ok.body.json
    }
}

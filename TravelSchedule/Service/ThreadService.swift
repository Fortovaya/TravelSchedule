//
//  ThreadService.swift
//  TravelSchedule
//
//  Created by Алина on 21.07.2025.
//

import OpenAPIRuntime

typealias ThreadStationsResponse = Components.Schemas.ThreadStationsResponse

protocol ThreadServiceProtocol: Actor{
    /// список станций следования нитки по указанному идентификатору нитки, информация о каждой нитке и о промежуточных станциях нитки
    func getRouteStations(uid: String) async throws -> ThreadStationsResponse
}

final actor ThreadService: ThreadServiceProtocol {
    
    private let client: Client
    private let apikey: String
    
    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }
    
    func getRouteStations(uid: String) async throws -> ThreadStationsResponse {
        let response = try await client.getRouteStations(query: .init(apikey: apikey, uid: uid))
        return try response.ok.body.json
    }
}

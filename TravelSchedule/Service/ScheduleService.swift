//
//  ScheduleService.swift
//  TravelSchedule
//
//  Created by Алина on 21.07.2025.
//

import OpenAPIRuntime

typealias ScheduleResponse = Components.Schemas.ScheduleResponse

protocol ScheduleServiceProtocol {
    ///  список рейсов, отправляющихся от указанной станции и информацию по каждому рейсу.
    func getStationSchedule(station: String) async throws -> ScheduleResponse
}

final class ScheduleService: ScheduleServiceProtocol {
    
    private let client: Client
    private let apikey: String
    
    init(client: Client, apikey: String){
        self.client = client
        self.apikey = apikey
    }
    
    func getStationSchedule(station: String) async throws -> ScheduleResponse {
        let response = try await client.getStationSchedule(query: .init(apikey: apikey, station: station))
        return try response.ok.body.json
    }
    
}

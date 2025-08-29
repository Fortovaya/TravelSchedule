//
//  CopyrightService.swift
//  TravelSchedule
//
//  Created by Алина on 21.07.2025.
//

import OpenAPIRuntime

typealias CopyrightResponse = Components.Schemas.CopyrightResponse

protocol CopyrightServiceProtocol: Actor {
    /// данные о Яндекс Расписаниях: URL сервиса, баннер в различных цветовых представлениях и уведомительный текст
    func getCopyright() async throws -> CopyrightResponse
}

final actor CopyrightService: CopyrightServiceProtocol {
    
    private let client: Client
    private let apikey: String
    
    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }
    
    func getCopyright() async throws -> CopyrightResponse {
        let response = try await client.getCopyright(query: .init(apikey: apikey))
        return try response.ok.body.json
    }
}

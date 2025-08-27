//
//  MockCityService.swift
//  TravelSchedule
//
//  Created by Алина on 27.08.2025.
//
import OpenAPIRuntime
import Foundation

@MainActor
class MockCityService: CityServiceProtocol {
    func getAllCities() async throws -> [City] {
        // Моковые данные для превью - создаем города без кодов
        return [
            City(title: "Москва", codes: nil),
            City(title: "Санкт-Петербург", codes: nil),
            City(title: "Сочи", codes: nil),
            City(title: "Казань", codes: nil),
            City(title: "Новосибирск", codes: nil)
        ]
    }
}

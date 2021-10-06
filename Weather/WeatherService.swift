//
//  WeatherService.swift
//  Weather
//
//  Created by David Post on 2021-10-06.
//

import Foundation
import Combine

class WeatherService: ObservableObject {
    @Published var errorMessage: String = ""
    @Published var current: Weather?
    @Published var forecast: [Weather] = []
    
    private var apiKey: String {
        var value: String
        do {
            value = try Configuration.value(for: "API_KEY")
        } catch {
            value = ""
        }
        return value
    }
    private var cancellableSet: Set<AnyCancellable> = []
}

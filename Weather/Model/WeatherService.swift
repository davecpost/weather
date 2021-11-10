//
//  WeatherService.swift
//  Weather
//
//  Created by David Post on 2021-10-06.
//

import Foundation
import Combine
import CoreLocation

class WeatherService: ObservableObject {
    @Published var errorMessage: String = ""
    @Published var current: Weather?
    @Published var forecast: [Weather] = []
    @Published var location: CLLocation?
    @Published var city: String?
    @Published var country: String?
    
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
    
    func load(location: CLLocation?) {
        guard let location = location else {
            return
        }
        self.location = location
        
        location.fetchCityAndCountry() { city, country, error in
            if let error = error {
                print(error)
                return
            }
            self.city = city
            self.country = country
        }

        let lat = location.coordinate.latitude
        let long = location.coordinate.longitude
        load(latitude: Float(lat), longitude: Float(long))
    }
    
    private func load(latitude: Float, longitude: Float) {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        let currentURL = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric")!
        URLSession.shared.dataTaskPublisher(for: URLRequest(url: currentURL))
            .map(\.data)
            .decode(type: Weather.self, decoder: decoder)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }, receiveValue: {
                self.current = $0
            })
            .store(in: &cancellableSet)
        
        let forecastURL = URL(string: "https://api.openweathermap.org/data/2.5/forecast?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric")!
        URLSession.shared
            .dataTaskPublisher(for: URLRequest(url: forecastURL))
            .map(\.data)
            .decode(type: ForecastWeather.self, decoder: decoder)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }, receiveValue: {
                self.forecast = $0.list
            })
            .store(in: &cancellableSet)
    }
}

extension Double {
    var formatted: String {
        String(format: "%.0f", self)
    }
}

extension Date {
    var formatted: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .medium
        
        return formatter.string(from: self)
    }
}

extension String {
    var weatherIcon: String {
        switch self {
        case "01d":
            return "sun.max"
        case "02d":
            return "cloud.sun"
        case "03d":
            return "cloud"
        case "04d":
            return "cloud.fill"
        case "09d":
            return "cloud.rain"
        case "10d":
            return "cloud.sun.rain"
        case "11d":
            return "cloud.bolt"
        case "13d":
            return "cloud.snow"
        case "50d":
            return "cloud.fog"
        case "01n":
            return "moon"
        case "02n":
            return "cloud.moon"
        case "03n":
            return "cloud"
        case "04n":
            return "cloud.fill"
        case "09n":
            return "cloud.rain"
        case "10n":
            return "cloud.moon.rain"
        case "11n":
            return "cloud.bolt"
        case "13n":
            return "cloud.snow"
        case "50n":
            return "cloud.fog"
        default:
            return "icloud.slash"
        }
    }
}

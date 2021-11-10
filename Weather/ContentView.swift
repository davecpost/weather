//
//  ContentView.swift
//  Weather
//
//  Created by David Post on 2021-10-06.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    @ObservedObject var weatherService = WeatherService()
    @ObservedObject var locationManager = LocationManager()
    var body: some View {
        VStack {
            Text(weatherService.errorMessage)
                .font(.largeTitle)
                .padding()
            if weatherService.current != nil {
                VStack {
                    if locationManager.city != nil && locationManager.country != nil {
                        Text(locationManager.city!).font(.largeTitle) + Text(", ").font(.title) + Text(locationManager.country!).font(.title)
                    }
                    CurrentWeather(current: weatherService.current!)
                    List {
                        ForEach(weatherService.forecast) {
                            WeatherRow(weather: $0)
                        }
                    }.refreshable() {
                        weatherService.load(location: locationManager.location)
                    }
                }
            } else {
                Image(systemName: "thermometer.sun.fill")
                    .resizable()
                    .scaledToFit()
                    .padding()
                Text("Loading Weather")
                    .font(.largeTitle)
                    .padding()
            }
        }.onReceive(locationManager.$location, perform: load)
    }
    
    func load(location: CLLocation?) {
        guard let location = location else {
            return
        }

        if weatherService.current == nil {
            weatherService.load(location: location)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

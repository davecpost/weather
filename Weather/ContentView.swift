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
                    if weatherService.city != nil && weatherService.country != nil {
                        Text(weatherService.city!).font(.largeTitle) + Text(", ").font(.title) + Text(weatherService.country!).font(.title)
                    }
                    CurrentWeather(current: weatherService.current!)
                    ScrollView {
                        PullToRefresh(coordinateSpaceName: "forecastList", onRefresh: refresh)
                        ForEach(weatherService.forecast) {
                            WeatherRow(weather: $0)
                        }
                    }.coordinateSpace(name: "forecastList")
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
    
    func refresh() {
        weatherService.load(location: locationManager.location)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

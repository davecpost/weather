//
//  ContentView.swift
//  Weather
//
//  Created by David Post on 2021-10-06.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var weatherService = WeatherService()
    var body: some View {
        VStack {
            Text(weatherService.errorMessage)
                .font(.largeTitle)
                .padding()
            if weatherService.current != nil {
                VStack {
                    CurrentWeather(current: weatherService.current!)
                    List {
                        ForEach(weatherService.forecast) {
                            WeatherRow(weather: $0)
                        }
                    }
                }
            } else {
                Button {
                    weatherService.load(latitude: 51.5074, longitude: 0.1278)
                } label: {
                    Text("Refresh Weather")
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 16)
                        .background(Color.green)
                        .cornerRadius(5)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

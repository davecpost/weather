//
//  WeatherRow.swift
//  Weather
//
//  Created by David Post on 2021-10-06.
//

import SwiftUI

struct WeatherRow: View {
    var weather: Weather
    var body: some View {
        HStack {
            Image(systemName: weather.icon.weatherIcon)
                .font(.largeTitle)
            VStack(alignment: .leading) {
                Text(weather.summary)
                Text(weather.time.formatted)
            }
            Spacer()
            Text("\(weather.temperature.formatted) °")
                .font(.largeTitle)
                .padding()
        }
    }
}

struct WeatherRow_Previews: PreviewProvider {
    static var previews: some View {
        WeatherRow(weather: Weather(time: Date(), summary: "Sunny", icon: "01d", temperature: 20))
    }
}

//
//  CurrentWeather.swift
//  Weather
//
//  Created by David Post on 2021-10-06.
//

import SwiftUI

struct CurrentWeather: View {
    var current: Weather
    var body: some View {
        VStack {
            Text(current.time.formatted)
            HStack {
                Image(systemName: current.icon.weatherIcon)
                    .font(.custom("Extra Large", size: 80))
                Text("\(current.temperature.formatted)°")
                    .font(.custom("Extra Large", size: 80))
            }
            Text(current.summary)
        }
    }
}

struct CurrentWeather_Previews: PreviewProvider {
    static var previews: some View {
        CurrentWeather(current: Weather(time: Date(), summary: "Sunny", icon: "01d", temperature: 20))
    }
}

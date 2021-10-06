//
//  ForecastWeather.swift
//  Weather
//
//  Created by David Post on 2021-10-06.
//

import Foundation

struct ForecastWeather: Decodable {
    let list: [Weather]
}

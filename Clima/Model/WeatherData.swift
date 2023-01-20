//
//  WeatherData.swift
//  Clima
//
//  Created by Uzkassa on 20/01/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation

struct Main: Codable{
    var temp: Double;
}

struct Weather: Codable{
    var id: Int;
    var description: String;
}

struct WeatherData: Codable{
    var name: String;
    var cod: Int;
    var main: Main;
    var weather: [Weather]
}

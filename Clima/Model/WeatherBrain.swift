//
//  WeatherBrain.swift
//  Clima
//
//  Created by Uzkassa on 20/01/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation;
struct WeatherBrain{
    let baseUrl = "https://api.openweathermap.org/data/2.5/weather?appid=d67f4af1ca55365ec4433dea21af9976";
    var delegate: CanUpdateWeather?;
    func fetchWeather(cityName: String){
        let url = URL(string: "\(baseUrl)&q=\(cityName)&units=metric");
        if let safeUrl = url {
            performRequest(url: safeUrl);
        }
    }
    func fetchWeatherByCoordinates(lat: CLLocationDegrees,lon: CLLocationDegrees){
        let url = URL(string: "\(baseUrl)&lat=\(lat)&lon=\(lon)&units=metric");
        if let safeUrl = url {
            performRequest(url: safeUrl);
        }
    }
    //MARK: Perform request
    private func performRequest(url:URL){
        let session = URLSession(configuration: .default);
        let task = session.dataTask(with: url, completionHandler: handleRequest(data:response:error:))
        task.resume();
    }
    private func handleRequest (data:Data?,response:URLResponse?,error:Error?){
        if  error != nil {
            print(error!);
            return;
        }
        if let safeData = data {
            let weather = parseJSON(weatherData: safeData);
            if let safeWeather = weather{
                delegate?.didUpdateWeather(safeWeather)
            }
        }
    }
//MARK: Parse JSON
    private func parseJSON (weatherData: Data) -> WeatherModel?{
        let decoder = JSONDecoder();
        do {
            let result = try decoder.decode(WeatherData.self, from: weatherData);
            let conditionId = result.weather[0].id;
            let temp = result.main.temp;
            let name = result.name;
            return WeatherModel(conditionID: conditionId, cityName: name, temperature: temp);
        } catch {
            delegate?.didUpdateWithError(message: error.localizedDescription)
            return nil;
        }
    }
}

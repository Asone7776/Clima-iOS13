//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation;
protocol CanUpdateWeather{
    func didUpdateWeather(_ weather:WeatherModel)
    func didUpdateWithError(message: String)
}
class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchField: UITextField!
    var brain = WeatherBrain();
    var locationManager = CLLocationManager();
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self;
        searchField.delegate = self;
        brain.delegate = self;
        locationManager.requestWhenInUseAuthorization();
        locationManager.requestLocation();
    }

    @IBAction func searchPressed(_ sender: UIButton) {
        searchField.endEditing(true);
    }
    @IBAction func onLocationPressed(_ sender: UIButton) {
        locationManager.requestLocation();
    }
    
}

extension WeatherViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchField.endEditing(true);
        return true;
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let cityName = textField.text{
            brain.fetchWeather(cityName: cityName);
        }
        textField.text = "";
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true;
        }
        return false;
    }
}

extension WeatherViewController:CanUpdateWeather{
    func didUpdateWithError(message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert);
            let action = UIAlertAction(title: "Close", style: .cancel);
            alert.addAction(action);
            self.present(alert,animated: true);
        }
    }
    
    func didUpdateWeather(_ weather: WeatherModel) {
        DispatchQueue.main.async {
            self.conditionImageView.image = UIImage(systemName: weather.conditionName);
            self.temperatureLabel.text = weather.temperatureString;
            self.cityLabel.text = weather.cityName;
        }
    }
}
extension WeatherViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let locationObj = locations.last{
            locationManager.stopUpdatingLocation();
            let coord = locationObj.coordinate;
            let lat = coord.latitude;
            let lon = coord.longitude;
            brain.fetchWeatherByCoordinates(lat: lat, lon: lon);
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
               print(error.localizedDescription);
        }
}

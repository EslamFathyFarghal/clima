//
//  WeatherHelper.swift
//  Clima
//
//  Created by Eslam Fathy on 4/23/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//


import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather (weatherData : WeatherModel)
    func didFailWithAnError (error : Error)
}

class WeatherHelper {
    
    let apiKey = "3b44ee64617b9d737d9c958e174ab0fb"
    let url = "https://api.openweathermap.org/data/2.5/weather?&units=metric"
    var delegate : WeatherManagerDelegate?
    
    
    func getWeather(city:String) {
        let u =  "\(url)&appid=\(apiKey)&q=\(city)"
        performRequest(url: u)
        
    }
    
    func getWeather(latitude: CLLocationDegrees , longitude: CLLocationDegrees) {
        let u =  "\(url)&appid=\(apiKey)&lat=\(latitude)&lon=\(longitude)"
        print(u)
        performRequest(url: u)
    }
    
    func performRequest(url :String) {
        
        if let u = URL(string: url) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: u) { (data, response, err) in
                if err != nil {
                    self.delegate?.didFailWithAnError(error: err!)
                    return
                }
                if let responseData = data {
                    if let weather = self.parseData(weatherData : responseData){
                        self.delegate?.didUpdateWeather(weatherData: weather)
                        
                    }
                }
            }
            task.resume()
            
        }
    }
    func parseData (weatherData : Data ) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            let weather = WeatherModel(conditionId: id, temperature: temp, cityName: name)
            return weather
        } catch {
            self.delegate?.didFailWithAnError(error: error)
            return nil
        }
    }
    
    
}

//
//  WeatherManager.swift
//  Clima
//
//  Created by Lago on 2021/01/02.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

//outside the structure, lecture 153 확인__넘나리 어렵다
//it makes possible to adopt on other programs when the subject is changed
protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=f37adfb5a2f0c1905d0762a0964e727a&units=metric"
    //https is much safer to adopt on xcode
    //api 빼오기_되는 사이트 있음
    //key의 순서는 상관없다, 항목만 다 들어있으면 ok
    
    var delegate: WeatherManagerDelegate?
    
    
    func fetchWeather(cityName: String){
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with : urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lon=\(longitude)&lat=\(latitude)"
        performRequest(with : urlString)
    }
    
    func performRequest(with urlString: String) {
        
        /*
         networking = requesting the server for the data by api to the app
         */
        //1. create URL
        if let url = URL(string: urlString) {
            //2. create URL cession
            let session = URLSession(configuration: .default)
            //3. Give url cession a task
            //let task = session.dataTask(with: url, completionHandler: handle(data: response: error: ))
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    //let dataString = String(data: safeData, encoding: .utf8)
                    // print(dataString)
                    if let weather = self.parseJson(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            //json = javascript object notation
            
            //4. start the task
            task.resume()
        }
    }
    
    func parseJson(_ weatherData:Data) -> WeatherModel? {
        let decoder = JSONDecoder() //bring the data from API
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            //print(decodedData.main.temp)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            
            //print(weather.conditionName)
            //print(weather.temperatureString)
            return weather

        } catch {
            delegate?.didFailWithError(error:error)
            return nil
        }
    }
    
    
}

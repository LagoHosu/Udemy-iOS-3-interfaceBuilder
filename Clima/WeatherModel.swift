//
//  WeatherModel.swift
//  Clima
//
//  Created by Lago on 2021/01/09.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation

struct WeatherModel {
    let conditionId: Int
    let cityName: String
    let temperature: Double
    
    //computed property
    //the value is always changing based on computed value
    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }

    var conditionName: String {
        switch conditionId {
        case 200...299 :
            return "cloud.volt"
        case 300...399 :
            return "cloud.drizzle"
        case 500...599 :
            return "cloud.rain"
        case 600...699 :
            return "cloud.snow"
        case 700...799 :
            return "cloud.fog"
        case 800 :
            return "sun.max"
        case 800...899 :
            return "cloud.bolt"
        default:
            return  "sun.max"
        }
    }
    
    
    
}


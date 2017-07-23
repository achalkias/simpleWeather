//
//  Forecast.swift
//  RainnyShinyCloudy
//
//  Created by Apostolos Chalkias on 22/07/2017.
//  Copyright © 2017 Apostolos Chalkias. All rights reserved.
//

import UIKit
import Alamofire

class Forecast {
    
    var _date: String!
    var _weatherType: String!
    var _highTemp: String!
    var _lowTemp: String!
    
    var date:String {
        if _date == nil {
            _date = ""}
        return _date
    }
    
    var weatherType:String {
        if _weatherType == nil {
            _weatherType = ""}
        return _weatherType
    }
    
    var highTemp:String {
        if _highTemp == nil {
            _highTemp = ""}
        return _highTemp
    }
    
    
    var lowTemp:String {
        if _lowTemp == nil {
            _lowTemp = ""}
        return _lowTemp
    }
    
    
    //Create an initializer 
    
    init(weatherDict: Dictionary<String,AnyObject>) {
        
        //Get the temp dictionary
        if let temp = weatherDict["temp"] as? Dictionary<String,AnyObject>{
            
            //Get the low temperature
            if let min = temp["min"] as? Double {
                let kelvinToCelsius = min - 273.15
                self._lowTemp = String(format: "%.0f", kelvinToCelsius) + "°"
            }
            
            
            //Get the high temperature
            if let max = temp["max"] as? Double {
                let kelvinToCelsius = max - 273.15
                self._highTemp = String(format: "%.0f", kelvinToCelsius) + "°"
            }
        
        }
        
        //Get the weather dictionary
        if let weather = weatherDict["weather"] as? [Dictionary<String, AnyObject>]{
            
            //Get the weather type
            if let main = weather[0]["main"] as? String {
                self._weatherType = main.capitalized
            }
        }
        
        if let date = weatherDict["dt"] as? Double {
            //Convert unix timestamp to Date
            let unixConvertedDate = Date(timeIntervalSince1970: date)
            let dateFormater = DateFormatter()
            dateFormater.dateStyle = .full
            dateFormater.dateFormat = "EEEE"
            dateFormater.timeStyle = .none
            self._date = unixConvertedDate.dayOfTheWeek()
        }
        
        
        
    }
}


//Create an extention to get the day of the week
extension Date {
    
    func dayOfTheWeek() -> String {
        
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "EEEE" // Get the full name of the day of the week
        return dateFormater.string(from: self)
    }
    
}




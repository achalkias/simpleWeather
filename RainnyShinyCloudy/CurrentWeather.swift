//
//  CurrentWeather.swift
//  RainnyShinyCloudy
//
//  Created by Apostolos Chalkias on 22/07/2017.
//  Copyright © 2017 Apostolos Chalkias. All rights reserved.
//

import UIKit
import Alamofire

class CurrentWeather {
    
    var _cityName: String!
    var _date: String!
    var _weatherType: String!
    var _currentTemp: Double!
    
    //Data encapsulation
    var cityName: String{
        if _cityName == nil {
            _cityName = ""
        }
        return _cityName
    }
    
    var date: String{
        if _date == nil {
            _date = ""
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        
        let currentDate = dateFormatter.string(from: Date())
        self._date = "Today, \(currentDate)"
        
        return _date
    }
    
    
    var weatherType: String{
        if _weatherType == nil {
            _weatherType = ""
        }
        return _weatherType
    }
    
    var currentTemp: Double{
        if _currentTemp == nil {
            _currentTemp = 0.0
        }
        return _currentTemp
    }
    
    
    func downloadWeatherDetails(completed: @escaping DownloadComplete){
        //Alamofire download
        let currentWeatherUrl = URL(string: CURRENT_WEATHER_URL)!
        
        print(currentWeatherUrl)
        
        Alamofire.request(currentWeatherUrl).responseJSON {
            
            //Pass the request into a response
            response in
            
            //Store the downloaded json
            let result = response.result
            
            
            
            //Create a dictionary to store data
            if let dict = result.value as? Dictionary<String, AnyObject>{
                
               
                //Get the city name
                if let name = dict["name"] as? String {
                    self._cityName = name.capitalized
                    print(self._cityName)
                }
                
                //Get weather type
                if let weather = dict["weather"] as? [Dictionary<String,AnyObject>]{
                    
                    //Get the first object of the array and get the main
                    if let main = weather[0]["main"] as? String {
                        self._weatherType = main.capitalized
                        print(self._weatherType)
                    }
                }
                
                
                //Get current temp
                if let name = dict["main"] as? Dictionary<String,AnyObject> {
                    
                    //Get the temp from the main dictionary
                    if let currentTemperature = name["temp"] as? Double {
                        
                        //Convert to celsius
                        
                        let kelvinToCelsius = currentTemperature - 273.15
                        
                        self._currentTemp = kelvinToCelsius
                        
                        print(self._currentTemp)
                    }
                }
                
            }
             completed()
            
        }
       
        
        
    }
}

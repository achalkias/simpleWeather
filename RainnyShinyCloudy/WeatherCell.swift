//
//  WeatherCell.swift
//  RainnyShinyCloudy
//
//  Created by Apostolos Chalkias on 22/07/2017.
//  Copyright © 2017 Apostolos Chalkias. All rights reserved.
//

import UIKit

class WeatherCell: UITableViewCell {

    //@IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weatherType: UILabel!
    @IBOutlet weak var highTemp: UILabel!
    @IBOutlet weak var lowTemp: UILabel!
   
    
    func configureCell(forecast: Forecast){
       
        //Set the labels
        lowTemp.text = forecast.lowTemp
        highTemp.text = forecast.highTemp
        weatherType.text = forecast.weatherType
        dayLabel.text = forecast.date
        
        //Set the icon
        weatherIcon.image = UIImage(named: forecast.weatherType)
        
    }


}

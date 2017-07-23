//
//  WeatherVC.swift
//  RainnyShinyCloudy
//
//  Created by Apostolos Chalkias on 22/07/2017.
//  Copyright © 2017 Apostolos Chalkias. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

class WeatherVC: UIViewController,UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    //@IBOutlets
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var currentTempLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var currentWeatherImage: UIImageView!
    @IBOutlet weak var currentWeatherLbl: UILabel!
    @IBOutlet weak var weatherTableView: UITableView!
    
    //Location Manager
    let locationManager = CLLocationManager()
    
    
    
    //Variables
    var currentWeather: CurrentWeather!
    var forecast: Forecast!
    var forecasts = [Forecast]()
    var currentLocation: CLLocation!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set the Location manager
        locationManager.delegate = self //Set Delegate
        locationManager.desiredAccuracy = kCLLocationAccuracyBest //Set the accuarcy to the best possible
        locationManager.requestWhenInUseAuthorization() //Use GPS only then the app is active and in use.
        locationManager.startMonitoringSignificantLocationChanges() //Keep track of any significant GPS changes.
        
        //Set tableView delgate and datasource
        weatherTableView.delegate = self
        weatherTableView.dataSource = self
        
        
       currentWeather = CurrentWeather()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationAuthStatus()
    }
    
    func locationAuthStatus(){
        //Check for location authorziation status
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            
            //Save the current location to currentLocation variable
            currentLocation = locationManager.location
            
            //Set location to our singleton class to be able to use the location anywhere in the app
            Location.sharedInstance.latitude = currentLocation.coordinate.latitude
            Location.sharedInstance.longitude = currentLocation.coordinate.longitude
            
            print(Location.sharedInstance.latitude , Location.sharedInstance.longitude)
            
           
            currentWeather.downloadWeatherDetails {
                //Setup UI to load downloaded data
                
                self.downloadForecastData {
                    //Call the function to update the UI
                    self.updateMainUI()
                }
            }
            
        } else{
            //Request user location authorization
            locationManager.requestWhenInUseAuthorization()
            //Request user authorization again
            locationAuthStatus()
        }
    }
    
    func downloadForecastData(completed: @escaping DownloadComplete){
        //Downloading forecast weather data for TableView
        
        let forecastURL = URL(string: FORECAST_URL)!
        Alamofire.request(forecastURL).responseJSON{ response in

            //Get the result
            let result = response.result
           
            //Print result
            print(result)
            
            //Create a dictionary
            if let dict = result.value as? Dictionary<String,AnyObject> {
                
                //Get the array of objects
                if let list = dict["list"] as? [Dictionary<String,AnyObject>]{
                    
                    //Create a loop to read the array
                    for obj in list {
                        
                        //Instatiate a forecast
                        let forecast = Forecast(weatherDict: obj)
                        
                        //Append element to array
                        self.forecasts.append(forecast)
                        
                        //Print object
                        print(obj)
                        
                    }
                    
                    //Remove the first index so the forecast will start from tomorow
                    self.forecasts.remove(at: 0)
                    
                    
                    //Notify the tableView that data has been loaded
                    self.weatherTableView.reloadData()
                    
                }
                
            }
            completed()
        }
        
    
    }
    
    
    
    //Delegate Functions
    func numberOfSections(in tableView: UITableView) -> Int {
        //Return 1 if any headers or anything else needed.
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //How many cells on the table view.
        return forecasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Recreate a cell so that it knows what recreate all the way down the tableView
        
        //Declare and create a cell and identify it by its identifier
        if let cell = weatherTableView.dequeueReusableCell(withIdentifier: "weatherCell" , for: indexPath) as? WeatherCell {
            
        
            //Get the object of the array from index
            let forecast = forecasts[indexPath.row]
            
            cell.configureCell(forecast: forecast)
            
            
            //And return the cell
            return cell
        } else {
            //Return an empty cell if for some reason the cell cannot be created
            return WeatherCell()
        }
        
        
        
    }
    
    func updateMainUI() {
        //Set the data to labels
        dateLbl.text = currentWeather.date
        currentTempLbl.text = String(format: "%.0f", currentWeather.currentTemp) + "°"
        currentWeatherLbl.text = currentWeather.weatherType
        locationLbl.text = currentWeather.cityName
        
        //Get the image from assets based on weatherType
        currentWeatherImage.image = UIImage(named: currentWeather.weatherType)
    }
    
    
    
}


//
//  Location.swift
//  RainnyShinyCloudy
//
//  Created by Apostolos Chalkias on 22/07/2017.
//  Copyright © 2017 Apostolos Chalkias. All rights reserved.
//


import CoreLocation


class Location {
    
    
    static var sharedInstance = Location()
   
    private init() {}
    
    var latitude: Double!
    var longitude: Double!
    
    
}

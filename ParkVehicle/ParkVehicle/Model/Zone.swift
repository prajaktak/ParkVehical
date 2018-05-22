//
//  Zone.swift
//  ParkVehicle
//
//  Created by Prajakta Kulkarni on 22/05/2018.
//  Copyright © 2018 Prajakta Kulkarni. All rights reserved.
//

import Foundation

struct Zone:Codable {
    var zoneId:String
    var zoneDetails:ZoneDetails
}
struct ZoneDetails:Codable{
    var address:String
    var lat: Double?
    var lon: Double?
    var tariff: String
}

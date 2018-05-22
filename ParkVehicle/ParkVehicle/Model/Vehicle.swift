//
//  Vehicle.swift
//  ParkVehicle
//
//  Created by Prajakta Kulkarni on 20/05/2018.
//  Copyright © 2018 Prajakta Kulkarni. All rights reserved.
//

import Foundation

struct Vehicle:Codable {
    var vehicleId:String
    var vehicleDetails:VehicleDetails
}
struct VehicleDetails:Codable {
    var isDefault:Bool
    var title:String
    var userId:String
    var vrn: String
}

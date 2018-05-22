//
//  ParkingAction.swift
//  ParkVehicle
//
//  Created by Prajakta Kulkarni on 20/05/2018.
//  Copyright © 2018 Prajakta Kulkarni. All rights reserved.
//

import Foundation

struct ParkingAction{
    var id:String
    var parkingActionDetails:ParkingActionDetails
    
}
struct ParkingActionDetails {
    var startDate:String?
    var stopDate: String?
    var userId:String?
    var vehicleId: String?
    var zoneId:String?
}

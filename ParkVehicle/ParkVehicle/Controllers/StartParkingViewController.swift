//
//  StartParkingViewController.swift
//  ParkVehicle
//
//  Created by Prajakta Kulkarni on 22/05/2018.
//  Copyright © 2018 Prajakta Kulkarni. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class StartParkingViewController: UIViewController,MKMapViewDelegate  {

    let apiManager =  APIManager()
    var zonesArray:[Zone]?
    var vehiclesArraay:[Vehicle]?
    var selectedZone:Zone?
    var selectedVehicle:Vehicle?
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var selectedZoneLabel: UILabel!
    @IBOutlet weak var selectedVehicleLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getZones()
        self.getVehicles()
        // Do any additional setup after loading the view.
    }
    func getVehicles()
    {
        var myDict: NSDictionary?
        if let path = Bundle.main.path(forResource: "API", ofType: "plist") {
            myDict = NSDictionary(contentsOfFile: path)
        }
        apiManager.getPosts(for: 1, path: myDict?.value(forKey: "GetVehicle") as! String){ (result) in
            
            // var data:User
            switch result{
            case .success(let value):
                do{
                    let data:NSDictionary = try JSONSerialization.jsonObject(with: value, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                    print(data)
                    self.vehiclesArraay = self.getVehicleObjects(vehicleInformationArray: data.allValues as NSArray, vehicleIdArray: data.allKeys as NSArray)
                    self.updateDefaultVehicle()
                    //data = try JSONDecoder().decode(User.self, from: value)
                    
                }catch{
                    
                }
                break
            case.failure(let error):
                print(error)
                break
            }
        }
    }
    func updateDefaultVehicle() {
        let userId = KeychainStorageManager.getUserIdFromKeychainStorage(accountName: Constants.keychainAccountName)
        let currentUserVehicle = self.vehiclesArraay?.filter({ (filterVehicle) -> Bool in
            filterVehicle.vehicleDetails.userId == userId
        })
        self.selectedVehicle = currentUserVehicle?.first
        if let title = currentUserVehicle?.first?.vehicleDetails.title{
            self.selectedVehicleLabel.text = Constants.selectedVehicleTitle + title
        }
        else
        {
            self.selectedVehicleLabel.text = Constants.selectedVehicleTitle + "No vehicle added."
        }
    }
    func getVehicleObjects(vehicleInformationArray : NSArray,vehicleIdArray:NSArray) -> [Vehicle] {
        var vehicleObjects = [Vehicle]()
        for index in 0...vehicleInformationArray.count-1{
            let vehicleID = vehicleIdArray[index] as! String
            let isDefault = (vehicleInformationArray[index] as! NSDictionary).value(forKey: "isDefault")
            let title = (vehicleInformationArray[index] as! NSDictionary).value(forKey: "title") as! String
            let userId = (vehicleInformationArray[index] as! NSDictionary).value(forKey: "userId") as! String
            let vrn = (vehicleInformationArray[index] as! NSDictionary).value(forKey: "vrn")as! String
            let vehicleObject = Vehicle(vehicleId: vehicleID, vehicleDetails: VehicleDetails(isDefault: isDefault as? Bool, title: title, userId: userId, vrn: vrn))
            vehicleObjects.append(vehicleObject)
        }
        return vehicleObjects
    }
    func getZones()
    {
        var myDict: NSDictionary?
        if let path = Bundle.main.path(forResource: "API", ofType: "plist") {
            myDict = NSDictionary(contentsOfFile: path)
        }
        apiManager.getPosts(for: 1, path: myDict?.value(forKey: "GetZones") as! String){ (result) in
            
            // var data:User
            switch result{
            case .success(let value):
                do{
                    let data:NSDictionary = try JSONSerialization.jsonObject(with: value, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                    self.zonesArray = self.getZoneObjects(zoneInformationArray: data.allValues as NSArray, zoneIdArray: data.allKeys as NSArray)
                    self.showZonesOnMap()
                    //data = try JSONDecoder().decode(User.self, from: value)
                    
                    print(data)
                }catch{
                    
                }
                break
            case.failure(let error):
                print(error)
                break
            }
        }
    }
    func getZoneObjects(zoneInformationArray : NSArray,zoneIdArray:NSArray) -> [Zone] {
        var zoneObjects = [Zone]()
        for index in 0...zoneInformationArray.count-1{
            let zoneID = zoneIdArray[index] as! String
            let address = (zoneInformationArray[index] as! NSDictionary).value(forKey: "address")as! String
            let lat = (zoneInformationArray[index] as! NSDictionary).value(forKey: "lat")
            let lon = (zoneInformationArray[index] as! NSDictionary).value(forKey: "lon")
            let tariff = (zoneInformationArray[index] as! NSDictionary).value(forKey: "tariff")as! String
            let zoneObject = Zone(zoneId: zoneID, zoneDetails: ZoneDetails(address: address, lat: lat as? Double, lon: lon as? Double, tariff: tariff))
            zoneObjects.append(zoneObject)
        }
        return zoneObjects
    }
    func showZonesOnMap() -> Void {
        let location =  CLLocationCoordinate2DMake(Constants.amsterdamLat, Constants.amsterdamLon)
        let span = MKCoordinateSpanMake(Constants.latSpanDelta, Constants.lonSpanDelta)
        let region = MKCoordinateRegionMake(location, span)
        mapView.setRegion(region, animated: true)
        
        for index in (zonesArray?.indices)!{
            if let lat  = zonesArray![index].zoneDetails.lat, let lon = zonesArray![index].zoneDetails.lon{
                let locationForAnnotation = CLLocationCoordinate2DMake(lat,lon)
                let annotation = MKPointAnnotation()
                annotation.coordinate = locationForAnnotation
                annotation.title = zonesArray![index].zoneDetails.address
                mapView.addAnnotation(annotation)
            }
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showParkingActionView" {
            let viewController = segue.destination as! ParkingActionViewController
            viewController.parkingActionDetails = NSMutableDictionary.init()
            let user = UserDefaults.standard.value(forKey: KeychainStorageManager.getUserIdFromKeychainStorage(accountName: Constants.keychainAccountName)) as! NSDictionary
            viewController.parkingActionDetails.setValue(user.value(forKey: "userName"), forKey: "userName")
            viewController.parkingActionDetails.setValue(zonesArray?.filter({ (currentZone) -> Bool in
                (((self.selectedZoneLabel.text?.range(of: currentZone.zoneDetails.address)) != nil))
            }).first?.zoneId, forKey: "zoneId")
            viewController.parkingActionDetails.setValue(self.selectedVehicle?.vehicleId, forKey: "vehicleId")
            let formatter = DateFormatter()
            // initially set the format based on your datepicker date / server String
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            let myString = formatter.string(from: Date())
            viewController.parkingActionDetails.setValue(myString, forKey: "Start time")
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Actions
    @IBAction func startParkingAction(_ sender: UIButton) {
        
    }
    @IBAction func menuAction(_ sender: UIButton) {
        
    }
    
    //MARK: - mapKit
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        self.selectedZoneLabel.text = Constants.selectedZoneTitle + ((view.annotation?.title)!)!
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

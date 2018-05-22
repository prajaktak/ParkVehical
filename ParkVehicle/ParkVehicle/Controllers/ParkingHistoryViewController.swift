//
//  ParkingHistoryViewController.swift
//  ParkVehicle
//
//  Created by Prajakta Kulkarni on 22/05/2018.
//  Copyright © 2018 Prajakta Kulkarni. All rights reserved.
//

import UIKit

class ParkingHistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
   
    var parkingHistoryArray = [ParkingAction]()
    var apiManager = APIManager()

    @IBOutlet weak var parkingHistoryTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        getParkingHistory()
        // Do any additional setup after loading the view.
    }
    func getParkingHistory() {
        var myDict: NSDictionary?
        if let path = Bundle.main.path(forResource: "API", ofType: "plist") {
            myDict = NSDictionary(contentsOfFile: path)
        }
        self.apiManager.GetData(form: myDict?.value(forKey: "GetParkingAction") as! String) { (result) in
            switch result{
            case .success(let value):
                do{
                    let data:NSDictionary = try JSONSerialization.jsonObject(with: value, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                    self.parkingHistoryArray = self.getParkingActionObjects(parkingActionsinformation: data.allValues as NSArray, parkingActionIds: data.allKeys as NSArray)
                    self.parkingHistoryTable.reloadData()
                    //self.userTableView .reloadData()
                    print(self.parkingHistoryArray)
                }catch{
                    
                }
                break
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    func getParkingActionObjects(parkingActionsinformation:NSArray, parkingActionIds:NSArray) -> [ParkingAction] {
        var parkingActionObjects = [ParkingAction]()
        for index in 0...parkingActionsinformation.count-1{
            let parkingActionID = parkingActionIds[index] as! String
            let userId = (parkingActionsinformation[index] as! NSDictionary).value(forKey: "userId")
            let vehicleId = (parkingActionsinformation[index] as! NSDictionary).value(forKey: "vehicleId")
            let zoneId = (parkingActionsinformation[index] as! NSDictionary).value(forKey: "zoneId")
            let startDate = (parkingActionsinformation[index] as! NSDictionary).value(forKey: "startDate")
            let stopDate = (parkingActionsinformation[index] as! NSDictionary).value(forKey: "stopDate")
            let parkingActionObject  = ParkingAction(id: parkingActionID, parkingActionDetails: ParkingActionDetails(startDate: startDate as? String, stopDate: stopDate as? String, userId: userId as? String, vehicleId: vehicleId as? String, zoneId: zoneId as? String))
            parkingActionObjects.append(parkingActionObject)
        }
         let userId = KeychainStorageManager.getUserIdFromKeychainStorage(accountName: Constants.keychainAccountName)
        return getParkingHistoryfor(userId: userId, from: parkingActionObjects)
    }
    func getParkingHistoryfor(userId:String, from array:[ParkingAction]) ->[ParkingAction] {
        let parkingActionArray = array.filter { (parkingAction) -> Bool in
            parkingAction.parkingActionDetails.userId == userId
        }
        return parkingActionArray
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK:- tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parkingHistoryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "parkingHistoryCell")
        cell?.textLabel?.text = " "
        cell?.textLabel?.numberOfLines = 0
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 12)
        cell?.textLabel?.adjustsFontSizeToFitWidth = true
        if parkingHistoryArray[indexPath.row].parkingActionDetails.zoneId != nil
        {
            cell?.textLabel?.text = parkingHistoryArray[indexPath.row].parkingActionDetails.zoneId! + " -- "
        }
        if parkingHistoryArray[indexPath.row].parkingActionDetails.vehicleId != nil
        {
            cell?.textLabel?.text =  (cell?.textLabel?.text)! + parkingHistoryArray[indexPath.row].parkingActionDetails.vehicleId! + " | "
        }
        if parkingHistoryArray[indexPath.row].parkingActionDetails.startDate != nil {
            cell?.textLabel?.text =  (cell?.textLabel?.text)! + parkingHistoryArray[indexPath.row].parkingActionDetails.startDate!
        }
        return cell!
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

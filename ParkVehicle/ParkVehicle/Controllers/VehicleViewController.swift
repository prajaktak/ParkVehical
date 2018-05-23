//
//  VehicleViewController.swift
//  ParkVehicle
//
//  Created by Prajakta Kulkarni on 23/05/2018.
//  Copyright © 2018 Prajakta Kulkarni. All rights reserved.
//

import UIKit

class VehicleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    var userVehicles = [Vehicle]()
    var apiManager = APIManager()
    
    @IBOutlet weak var vehicleTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getVehicles()
        // Do any additional setup after loading the view.
    }
    func getVehicles()
    {
        var myDict: NSDictionary?
        if let path = Bundle.main.path(forResource: "API", ofType: "plist") {
            myDict = NSDictionary(contentsOfFile: path)
        }
        apiManager.GetData(form: myDict?.value(forKey: "GetVehicle") as! String){ (result) in
            
            // var data:User
            switch result{
            case .success(let value):
                do{
                    let data:NSDictionary = try JSONSerialization.jsonObject(with: value, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                    print(data)
                    self.userVehicles = self.getVehicleObjects(vehicleInformationArray: data.allValues as NSArray, vehicleIdArray: data.allKeys as NSArray)
                    self.vehicleTable.reloadData()
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
    func getVehicleObjects(vehicleInformationArray : NSArray,vehicleIdArray:NSArray) -> [Vehicle] {
        var vehicleObjects = [Vehicle]()
        for index in 0...vehicleInformationArray.count-1{
            let vehicleID = vehicleIdArray[index] as! String
            let isDefault = (vehicleInformationArray[index] as! NSDictionary).value(forKey: "isDefault")
            let title = (vehicleInformationArray[index] as! NSDictionary).value(forKey: "title") as! String
            let userId = (vehicleInformationArray[index] as! NSDictionary).value(forKey: "userId") as! String
            let vrn = (vehicleInformationArray[index] as! NSDictionary).value(forKey: "vrn")as! String
            let vehicleObject = Vehicle(vehicleId: vehicleID, vehicleDetails: VehicleDetails(isDefault: isDefault as? Bool, title: title, userId: userId, vrn: vrn))
            if(userId == KeychainStorageManager.getUserIdFromKeychainStorage(accountName: Constants.keychainAccountName))
            {
                vehicleObjects.append(vehicleObject)
            }
        }
        return vehicleObjects
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Action
    
    @IBAction func addNewVehicleAction(_ sender: UIButton) {
    
    }
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (userVehicles.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 12)
        cell?.textLabel?.numberOfLines = 0
        cell?.textLabel?.text =  (self.userVehicles[indexPath.row].vehicleDetails.vrn) + " | " + (self.userVehicles[indexPath.row].vehicleDetails.title)
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

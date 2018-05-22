//
//  ParkingActionViewController.swift
//  ParkVehicle
//
//  Created by Prajakta Kulkarni on 22/05/2018.
//  Copyright © 2018 Prajakta Kulkarni. All rights reserved.
//

import UIKit

class ParkingActionViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var parkingActionDetails:NSMutableDictionary!
    var keys:NSArray!
    var values:NSArray!
    var apiManager = APIManager()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        keys = parkingActionDetails.allKeys as NSArray
        values = parkingActionDetails.allValues as NSArray
        
        //apiManager.submit
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        var myDict: NSDictionary?
        if let path = Bundle.main.path(forResource: "API", ofType: "plist") {
            myDict = NSDictionary(contentsOfFile: path)
        }
        apiManager.post(data: parkingActionDetails, path: myDict?.value(forKey: "CreateParkingAction") as! String) { (error,string) in
      
                print(error ?? "Posted successfully")
            self.parkingActionDetails.setValue(string, forKey: "parkingActionId")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: - tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return parkingActionDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "parkingActionCell") as! ParkingActionTableViewCell
        
        cell.titleLabel.text = " " + (keys[indexPath.row] as? String)!
        cell.valueLabel.text = " " + (values[indexPath.row] as? String)!
        return cell
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var myDict: NSDictionary?
        if let path = Bundle.main.path(forResource: "API", ofType: "plist") {
            myDict = NSDictionary(contentsOfFile: path)
        }
        var path = myDict?.value(forKey: "PatchParkingAction") as! String
        path = path.replacingOccurrences(of: "userId", with: parkingActionDetails.value(forKey: "parkingActionId") as! String)
        apiManager.patch(data: parkingActionDetails, path: path) { (error,string) in
            
            print(error ?? "Posted successfully")
            //self.parkingActionDetails.setValue(string, forKey: "parkingActionId")
        }

        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 

}

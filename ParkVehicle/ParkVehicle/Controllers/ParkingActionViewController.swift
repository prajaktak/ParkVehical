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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        keys = parkingActionDetails.allKeys as NSArray
        values = parkingActionDetails.allValues as NSArray
        // Do any additional setup after loading the view.
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

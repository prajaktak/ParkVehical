//
//  VehicleViewController.swift
//  ParkVehicle
//
//  Created by Prajakta Kulkarni on 23/05/2018.
//  Copyright © 2018 Prajakta Kulkarni. All rights reserved.
//

import UIKit

class VehicleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    var userVehicles:[Vehicle]?
    var apiManager = APIManager()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Action
    
    @IBAction func addNewVehicleAction(_ sender: UIButton) {
    
    }
    @IBAction func backAction(_ sender: UIButton) {
    }
    
    //MARK:- tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (userVehicles?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 12)
        cell?.textLabel?.numberOfLines = 0
        cell?.textLabel?.text =  (self.userVehicles?[indexPath.row].vehicleDetails.vrn)! + (self.userVehicles?[indexPath.row].vehicleDetails.title)!
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

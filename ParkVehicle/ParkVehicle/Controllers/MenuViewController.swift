//
//  MenuViewController.swift
//  ParkVehicle
//
//  Created by Prajakta Kulkarni on 22/05/2018.
//  Copyright © 2018 Prajakta Kulkarni. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var menuArray = ["Profile","History","Logout","Dismiss"]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return menuArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = menuArray[indexPath.row]
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var segueIdentifier = ""
        switch indexPath.row {
        case 0:
            segueIdentifier = "showProfile"
            break
        case 1:
            segueIdentifier = "showHistory"
            break
        case 2:
            segueIdentifier = "logout"
        case 3:
            segueIdentifier = "dismiss"
        default:
            segueIdentifier = ""
        }
        
        if segueIdentifier != "" && segueIdentifier != "dismiss"{
            
            self.performSegue(withIdentifier: segueIdentifier, sender: self)
        }
        else
        {
            self.navigationController?.popViewController(animated: true)
        }
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

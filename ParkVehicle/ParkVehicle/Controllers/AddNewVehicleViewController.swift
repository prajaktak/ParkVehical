//
//  AddNewVehicleViewController.swift
//  ParkVehicle
//
//  Created by Prajakta Kulkarni on 23/05/2018.
//  Copyright © 2018 Prajakta Kulkarni. All rights reserved.
//

import UIKit

class AddNewVehicleViewController: UIViewController {

    @IBOutlet weak var vehicleTitleTextField: UITextField!
    @IBOutlet weak var vehicleVRNTextField: UITextField!
    var apiManager =  APIManager()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Action
    @IBAction func addVehicleAction(_ sender: UIButton) {
        var myDict: NSDictionary?
        if let path = Bundle.main.path(forResource: "API", ofType: "plist") {
            myDict = NSDictionary(contentsOfFile: path)
        }
        let userId = KeychainStorageManager.getUserIdFromKeychainStorage(accountName: Constants.keychainAccountName)
        let vehicleDictionary = NSDictionary(dictionaryLiteral: ("userId",userId),("title",vehicleTitleTextField.text ?? "title"),("vrn",vehicleVRNTextField.text ?? "vrn"))
        apiManager.post(data: vehicleDictionary, path: myDict?.value(forKey: "PostNewVehicle") as! String) { (error,string) in
            
            print(error ?? "Posted successfully")
        }
    }
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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

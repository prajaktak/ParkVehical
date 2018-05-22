//
//  ViewController.swift
//  ParkVehicle
//
//  Created by Prajakta Kulkarni on 18/05/2018.
//  Copyright © 2018 Prajakta Kulkarni. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    let apiManager =  APIManager()
    
    @IBOutlet weak var userTableView: UITableView!
    
    var myDict: NSDictionary?
    var usersArray:[User]?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let path = Bundle.main.path(forResource: "API", ofType: "plist") {
            myDict = NSDictionary(contentsOfFile: path)
        }
        
        getUsers()
        // Do any additional setup after loading the view, typically from a nib.
    }
    func getUsers()
    {
        apiManager.getPosts(for: 1, path: myDict?.value(forKey: "GetUser") as! String){ (result) in
            
            // var data:User
            switch result{
            case .success(let value):
                do{
                    let data:NSDictionary = try JSONSerialization.jsonObject(with: value, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                    self.usersArray = self.getUserObjects(userInformationArray: data.allValues as NSArray, userIdArray: data.allKeys as NSArray)
                    self.userTableView .reloadData()
                    //print(data.allKeys)
                }catch{
                    
                }
                break
            case.failure(let error):
                print(error)
                break
            }
        }
    }
    func getUserObjects(userInformationArray : NSArray, userIdArray:NSArray) -> [User] {
        var userObjects = [User]()
        for index in 0...userInformationArray.count-1{
            let userID = userIdArray[index] as! String
            let firstName = (userInformationArray[index] as! NSDictionary).value(forKey: "firstName")as! String
            let lastName = (userInformationArray[index] as! NSDictionary).value(forKey: "lastName")as! String
            let userName = (userInformationArray[index] as! NSDictionary).value(forKey: "userName")as! String
            let userObject = User(userId: userID, userDetails: UserDetails(firstName: firstName, lastName: lastName, username: userName))
            userObjects.append(userObject)
        }
        return userObjects
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Actions
    
    @IBAction func CreateNewUserAction(_ sender: UIButton) {
        
    }
    //MARK: - Table view Delegate and datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if usersArray != nil
        {
            return (usersArray?.count)!
        }
        else
        {
            return 0
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let firstName = (usersArray![indexPath.row]).userDetails.firstName
        let lastName =  (usersArray![indexPath.row]).userDetails.lastName
            cell.textLabel?.text = firstName + " " + lastName
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userId = usersArray![indexPath.row].userId
        KeychainStorageManager.saveUserIDToKeychainStorage(selectedUserId: userId, accountName: Constants.keychainAccountName)
        //print(KeychainStorageManager.getUserIdFromKeychainStorage(accountName: Constants.keychainAccountName))
        self.performSegue(withIdentifier:"showStartParkingView", sender: self)
    }
 
}


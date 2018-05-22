//
//  ParkVehicleTests.swift
//  ParkVehicleTests
//
//  Created by Prajakta Kulkarni on 18/05/2018.
//  Copyright © 2018 Prajakta Kulkarni. All rights reserved.
//

import XCTest
@testable import ParkVehicle

class ParkVehicleTests: XCTestCase {
    var apiManager:APIManager!
    override func setUp() {
        super.setUp()
         apiManager =  APIManager()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    func testValidUsersApiCallReturnsListOfUsers()
    {
        //given
        var myDict: NSDictionary?
        if let path = Bundle.main.path(forResource: "API", ofType: "plist") {
            myDict = NSDictionary(contentsOfFile: path)
        }
        let expect = expectation(description: "get users from API")
        //when
        apiManager.GetData(form: myDict?.value(forKey: "GetUser") as! String){ (result) in
            
           // var data:User
            switch result{
            case .success(let value):
                do{
                    let data:NSDictionary = try JSONSerialization.jsonObject(with: value, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                    //data = try JSONDecoder().decode(User.self, from: value)
                    
                    print(data.allKeys)
                }catch{
                    
                }
                break
            case.failure(let error):
                print(error)
                break
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 10)
        //then
        
        
    }
    
    func testValidVehicleApiCallReturnsListOfVehicles()
    {
        //given
        var myDict: NSDictionary?
        if let path = Bundle.main.path(forResource: "API", ofType: "plist") {
            myDict = NSDictionary(contentsOfFile: path)
        }
        let expect = expectation(description: "get vehicle from api")
        //when
        apiManager.GetData(form:myDict?.value(forKey: "GetVehicle") as! String){ (result) in
            
            // var data:User
            switch result{
            case .success(let value):
                do{
                    let data:NSDictionary = try JSONSerialization.jsonObject(with: value, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                    //data = try JSONDecoder().decode(User.self, from: value)
                    
                    print(data)
                }catch{
                    
                }
                break
            case.failure(let error):
                print(error)
                break
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 10)
        //then
    }
    func testValidZonesApiCallReturnsListOfZones()
    {
        //given
        var myDict: NSDictionary?
        if let path = Bundle.main.path(forResource: "API", ofType: "plist") {
            myDict = NSDictionary(contentsOfFile: path)
        }
        let expect = expectation(description: "get zones from api")
        //when
        apiManager.GetData(form:myDict?.value(forKey: "GetZones") as! String){ (result) in
            
            // var data:User
            switch result{
            case .success(let value):
                do{
                    let data:NSDictionary = try JSONSerialization.jsonObject(with: value, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                    //data = try JSONDecoder().decode(User.self, from: value)
                    
                    print(data)
                }catch{
                    
                }
                break
            case.failure(let error):
                print(error)
                break
            }
            expect.fulfill()
        }
        wait(for: [expect], timeout: 10)
        //then
        
        
    }
    func testPostDataToParkingAction() {
        //given
        var myDict: NSDictionary?
        if let path = Bundle.main.path(forResource: "API", ofType: "plist") {
            myDict = NSDictionary(contentsOfFile: path)
        }
        let dataDictionary:NSDictionary = NSDictionary(dictionaryLiteral: ("userId","-LA55HuEow2e-U1BdLUK"),("vehicleId","-LD75PQgAmweK26hegu3"),("zoneID","-LD6UIIDwjyH-RMMKWfS"),("startDate","22-05-2018"))
        let expect = expectation(description: "Save data by create parking action api")
        
        //when
        apiManager.post(data: dataDictionary, path:myDict?.value(forKey: "CreateParkingAction") as! String) { (error,string) in
            
            //then
            XCTAssertNil(error)
            XCTAssertNotNil(string)
            expect.fulfill()
        }
        wait(for: [expect], timeout: 20)
    }

    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}

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
    func testAsyncFive()
    {
        //given
        let expect = expectation(description: "waitForFive")
        
        //when
        apiManager.waitForFive(){(result) in
            assert(result == 5)
            expect.fulfill()

        }
        wait(for: [expect], timeout: 10)
    }
    func testValidUsersApiCallReturnsListOfUsers()
    {
        //given
        var myDict: NSDictionary?
        if let path = Bundle.main.path(forResource: "API", ofType: "plist") {
            myDict = NSDictionary(contentsOfFile: path)
        }
        let expect = expectation(description: "getPosts")
        //when
        apiManager.getPosts(for: 1, path: myDict?.value(forKey: "GetUser") as! String){ (result) in
            
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
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}

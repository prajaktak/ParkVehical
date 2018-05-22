//
//  APIManager.swift
//  ParkVehicle
//
//  Created by Prajakta Kulkarni on 19/05/2018.
//  Copyright © 2018 Prajakta Kulkarni. All rights reserved.
//

import Foundation

class APIManager{
    enum Result<Value> {
        case success(Value)
        case failure(Error)
    }
    
   
    
    func getPosts(for userId: Int, path:String, completion: ((Result<Data>) -> Void)?) {
        var urlComponents = URLComponents()
        var myDict: NSDictionary?
        if let path = Bundle.main.path(forResource: "API", ofType: "plist") {
            myDict = NSDictionary(contentsOfFile: path)
        }
        if let dict = myDict {
            urlComponents.scheme = dict.value(forKey: "scheme") as? String
            urlComponents.host = dict.value(forKey: "host") as? String
            urlComponents.path = path
            
            guard let url = urlComponents.url else { fatalError("Could not create URL from components") }
            
            print(url)
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            let task = session.dataTask(with: request) { (responseData, response, responseError) in
                DispatchQueue.main.async {
                    if let error = responseError {
                        completion?(.failure(error))
                    } else if let jsonData = responseData {
                        // Now we have jsonData, Data representation of the JSON returned to us
                        // from our URLRequest...
                        
                        // Create an instance of JSONDecoder to decode the JSON data to our
                        // Codable struct
                        //let decoder = JSONDecoder()
                        
                        do {
                            // We would use Post.self for JSON representing a single Post
                            // object, and [Post].self for JSON representing an array of
                            // Post objects
//                            let posts = try decoder.decode(User.self, from: jsonData)
//                            completion?(.success(posts))
                            completion?(.success(jsonData))
                        }
//                        catch {
//                            completion?(.failure(error))
//                        }
                    } else {
                        let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Data was not retrieved from request"]) as Error
                        completion?(.failure(error))
                    }
                }
            }
            
            task.resume()
        }
        
    }
    
    func submitPost(post: User, completion:((Error?) -> Void)?) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "jsonplaceholder.typicode.com"
        urlComponents.path = "/posts"
        guard let url = urlComponents.url else { fatalError("Could not create URL from components") }
        
        // Specify this request as being a POST method
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        // Make sure that we include headers specifying that our request's HTTP body
        // will be JSON encoded
        var headers = request.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        request.allHTTPHeaderFields = headers
        
        // Now let's encode out Post struct into JSON data...
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(post)
            // ... and set our request's HTTP body
            request.httpBody = jsonData
            print("jsonData: ", String(data: request.httpBody!, encoding: .utf8) ?? "no body data")
        } catch {
            completion?(error)
        }
        
        // Create and run a URLSession data task with our JSON encoded POST request
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            guard responseError == nil else {
                completion?(responseError!)
                return
            }
            
            // APIs usually respond with the data you just sent in your POST request
            if let data = responseData, let utf8Representation = String(data: data, encoding: .utf8) {
                print("response: ", utf8Representation)
            } else {
                print("no readable data received in response")
            }
        }
        task.resume()
    }
}

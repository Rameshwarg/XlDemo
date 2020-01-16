//
//  APICall.swift
//  XMLParsingDemo
//
//  Created by Sandeep Kakde on 01/12/19.
//  Copyright © 2019 Sandeep Kakde. All rights reserved.
//

public typealias CompletionHandler = (_ data: Data?,_ response: URLResponse?,_ error: Error?)->()

import Foundation

class APICall {

    public func getNewsData( _ completion: @escaping CompletionHandler) {
        if let url = URL(string: "http://feeds.reuters.com/reuters/technologyNews") {
            do {
                let task = URLSession.shared.dataTask(with: url) { data, response, error in
                    guard let data = data, error == nil else {
                        print(error ?? "Unknown error")
                        return
                    }
                    completion(data, response, error)
                }
                task.resume()
            } catch {
                completion(nil, nil, error)

            }
        }
    }
    
    
}

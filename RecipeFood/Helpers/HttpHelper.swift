//
//  HttpHelper.swift
//  RecipeFood
//
//  Created by TienPV on 12/4/18.
//  Copyright © 2018 TienPV. All rights reserved.
//

import Foundation

public class HttpHelperRequest
{
    public static func FetchHttpGet(with : URL!, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)
    {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = TimeInterval(15)
        config.timeoutIntervalForResource = TimeInterval(15)
        let urlSession = URLSession(configuration: config)
        
        urlSession.dataTask(with : with, completionHandler : completionHandler).resume()
    }
}

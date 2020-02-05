//
//  HttpHelper.swift
//  RecipeFoodTest
//
//  Created by TienPV on 12/4/18.
//  Copyright © 2018 TienPV. All rights reserved.
//

import Foundation

public class RecipeItem
{
    public static var CurrentRecipeId : Int!
    
    public var Id : Int!
    public var PreviewImg : String!
    public var RecipeName : String!
    public var DifficultLevel : String!
    public var NbReserving : Int!
    
    public init(id : Int!, previewImg : String!, name : String!, difficult : String!, nbReserving : Int!)
    {
        self.Id = id
        self.PreviewImg = previewImg
        self.RecipeName = name
        self.NbReserving = nbReserving
        self.DifficultLevel = difficult
    }
}

public class Category
{
    public static var Instance : Array<Category>? = Array<Category>()
    public static var CurrentCategoryId : Int = -1
    public static var CurrentCategoryName : String = ""
    
    public var Id : Int!
    public var CategoryName : String!
    public var BgImg : String!
    public var TotalOfRecipes : Int!
    
    public init(id : Int!, categoryName : String!, bgImg : String!, totalOfRecipes : Int!)
    {
        self.Id = id
        self.CategoryName = categoryName
        self.BgImg = bgImg
        self.TotalOfRecipes = totalOfRecipes
    }
}

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

//
//  Category.swift
//  RecipeFood
//
//  Created by TienPV on 2020/02/05.
//  Copyright © 2020 TienPV. All rights reserved.
//

import Foundation

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
    
    public init?(json: [String: Any]) {
        guard let id = json["Id"] as? Int,
            let categoryName = json["CategoryName"] as? String,
            let bgImageUrl = json["BgImageUrl"] as? String
        else {
            return nil
        }
        self.Id = id
        self.CategoryName = categoryName
        self.BgImg = bgImageUrl
        self.TotalOfRecipes = 0
    }
}

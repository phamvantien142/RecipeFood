//
//  RecipeItem.swift
//  RecipeFood
//
//  Created by TienPV on 2020/02/05.
//  Copyright © 2020 TienPV. All rights reserved.
//

import Foundation

public class RecipePreview
{
    public var Id : Int!
    public var CategoryId : Int!
    public var PreviewImg : String!
    public var RecipeName : String!
    public var DifficultLevel : String!
    public var NbReserving : Int!
    
    public init?(json: [String: Any]) {
        guard let id = json["Id"] as? Int,
            let previewImg = json["PreviewImage"] as? String,
            let recipeName = json["RecipeName"] as? String,
            let difficultLevel = json["DifficultLevel"] as? String,
            let nbReserving = json["NbReserving"] as? Int,
            let categoryId = json["CategoryId"] as? Int
        else {
            return nil
        }
        self.Id = id
        self.PreviewImg = previewImg
        self.RecipeName = recipeName
        self.DifficultLevel = difficultLevel
        self.NbReserving = nbReserving
        self.CategoryId = categoryId
    }
}

public class RecipeItem
{
    public static var CurrentRecipeId : Int!
    
    public var Id : Int!
    public var Summary : String!
    public var RecipeArray : Array<String>!
    public var ImageLst : Array<Array<String>>!
    public var Content : String?

    
    public init?(json: [String: Any]) {
        guard let id = json["Id"] as? Int,
            let summary = json["Summary"] as? String,
            let content = json["Content"] as? String,
            let imageLst = json["ImageLink"] as? String,
            let recipes = json["Recipes"] as? String
        else {
            return nil
        }
        self.ImageLst = Array<Array<String>>()
        self.RecipeArray = Array<String>()
        self.Id = id
        self.Summary = summary
        self.Content = content
        self.RecipeArray = recipes.components(separatedBy: ",")
        do {
            var message2 = try JSONSerialization.jsonObject(with: imageLst.data(using: .utf8)!, options:.mutableContainers) as AnyObject
            for anyObj in message2 as! Array<AnyObject>
            {
                var imageUrlLst:Array<String> = Array<String>()
                for anyObj2 in anyObj as! Array<AnyObject>
                {
                    imageUrlLst.append(anyObj2 as! String)
                }
                self.ImageLst?.append(imageUrlLst)
            }
        }
        catch let error as NSError
        {
            print("An error occurred: \(error)")
        }
    }
}

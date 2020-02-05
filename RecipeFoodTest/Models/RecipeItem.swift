//
//  RecipeItem.swift
//  RecipeFoodTest
//
//  Created by TienPV on 2020/02/05.
//  Copyright © 2020 TienPV. All rights reserved.
//

import Foundation


public class RecipeItem
{
    public static var CurrentRecipeId : Int!
    
    public var Id : Int!
    public var PreviewImg : String!
    public var RecipeName : String!
    public var DifficultLevel : String!
    public var Summary : String!
    public var NbReserving : Int!
    public var RecipeArray : Array<String>!
    public var ImageLst : Array<Array<String>>!
    public var ContentLst : Array<String>?

    
    public init(id : Int!, previewImg : String!, name : String!, difficult : String!, nbReserving : Int!)
    {
        self.Id = id
        self.PreviewImg = previewImg
        self.RecipeName = name
        self.NbReserving = nbReserving
        self.DifficultLevel = difficult
    }
    
    public init?(json: [String: Any]) {
        guard let id = json["Id"] as? Int,
            let previewImg = json["PreviewImage"] as? String,
            let recipeName = json["RecipeName"] as? String,
            let summary = json["Summary"] as? String,
            let difficultLevel = json["DifficultLevel"] as? String,
            let content = json["Content"] as? String,
            let nbReserving = json["NbReserving"] as? Int,
            let categoryId = json["CategoryId"] as? Int
        else {
            return nil
        }
        self.ImageLst = Array<Array<String>>()
        self.RecipeArray = Array<String>()
        self.Id = id
        self.PreviewImg = previewImg
        self.RecipeName = recipeName
        self.DifficultLevel = difficultLevel
        self.NbReserving = nbReserving
        self.Summary = summary
    }
}

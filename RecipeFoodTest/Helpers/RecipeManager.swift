//
//  RecipeManager.swift
//  RecipeFoodTest
//
//  Created by TienPV on 2020/02/05.
//  Copyright © 2020 TienPV. All rights reserved.
//

import Foundation

public class RecipeManager {
    public static var CategoriesInstance : Array<Category>? = Array<Category>()
    public static var RecipesInstance : Array<RecipeItem>? = Array<RecipeItem>()
    public static var CurrentCategoryId : Int = -1
    public static var CurrentCategoryName : String = ""

    public static func LoadAllCategories(jsonWithArrayRoot: [Any]) {
        for objectItem in jsonWithArrayRoot {
            // access all objects in array
            CategoriesInstance?.append(Category(json: objectItem as! [String : Any])!)
        }
    }
    
    public static func LoadAllRecipes(jsonWithArrayRoot: [Any]) {
        for objectItem in jsonWithArrayRoot {
            // access all objects in array
            RecipesInstance?.append(RecipeItem(json: objectItem as! [String : Any])!)
        }
    }
}

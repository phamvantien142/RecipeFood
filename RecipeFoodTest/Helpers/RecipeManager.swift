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
    public static var RecipesPreviewInstance : Array<RecipePreview>? = Array<RecipePreview>()
    public static var RecipesDetailInstance : Array<RecipeItem>? = Array<RecipeItem>()
    public static var CurrentRecipe : RecipePreview?
    public static var CurrentCategoryId : Int = -1
    public static var CurrentCategoryName : String = ""
    public static var CategoryCounter : Dictionary<Int, Int>? = Dictionary<Int, Int>()
    public static let Group = DispatchGroup()

    public static func LoadAllCategories(jsonWithArrayRoot: [Any]) {
        for objectItem in jsonWithArrayRoot {
            // access all objects in array
            CategoriesInstance?.append(Category(json: objectItem as! [String : Any])!)
        }
    }
    
    public static func LoadAllRecipePreviews(jsonWithArrayRoot: [Any]) {
        for objectItem in jsonWithArrayRoot {
            // access all objects in array
            var recipePreview = RecipePreview(json: objectItem as! [String : Any])!
            RecipesPreviewInstance?.append(recipePreview)
            if (CategoryCounter![recipePreview.CategoryId] == nil) {
                CategoryCounter![recipePreview.CategoryId] = 0
            }
            CategoryCounter![recipePreview.CategoryId]! += 1
        }
    }
    public static func LoadAllRecipeDetails(jsonWithArrayRoot: [Any]) {
        for objectItem in jsonWithArrayRoot {
            // access all objects in array
            var recipePreview = RecipeItem(json: objectItem as! [String : Any])!
            RecipesDetailInstance?.append(recipePreview)
        }
    }
}

//
//  ViewController.swift
//  RecipeFood
//
//  Created by TienPV on 12/2/18.
//  Copyright © 2018 TienPV. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    func getStringDataFromName(name: String) -> Any {
        let asset = NSDataAsset(name: name, bundle: Bundle.main)
        return String(data: asset!.data, encoding: .utf8)!
    }
    
    func getJsonDataFromName(name: String) -> [Any] {
        let asset = NSDataAsset(name: name, bundle: Bundle.main)
        //return String(data: asset!.data, encoding: .utf8)!
        return try! JSONSerialization.jsonObject(with: asset!.data, options: []) as! [Any]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.showSpinner(onView: self.view)
        DispatchQueue.global(qos: .background).async {
            let categoryStr = self.getJsonDataFromName(name: "categories")
            let recipePreviewStr = self.getJsonDataFromName(name: "recipePreviews")
            RecipeManager.LoadAllCategories(jsonWithArrayRoot: categoryStr)
            RecipeManager.LoadAllRecipePreviews(jsonWithArrayRoot: recipePreviewStr)
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "goToTabBar", sender: self)
                self.removeSpinner()
            }
            RecipeManager.Group.enter()
            RecipeManager.LoadAllRecipeDetails(jsonWithArrayRoot: self.getJsonDataFromName(name: "recipeDetails"))
            RecipeManager.Group.leave()
        }
    }

}


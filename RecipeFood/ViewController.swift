//
//  ViewController.swift
//  RecipeFood
//
//  Created by TienPV on 12/2/18.
//  Copyright © 2018 TienPV. All rights reserved.
//

import UIKit

var vSpinner : UIView?
extension UIViewController {
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            vSpinner?.removeFromSuperview()
            vSpinner = nil
        }
    }
}

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


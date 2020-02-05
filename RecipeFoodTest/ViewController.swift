//
//  ViewController.swift
//  RecipeFood
//
//  Created by TienPV on 12/2/18.
//  Copyright © 2018 TienPV. All rights reserved.
//

import UIKit
import SVProgressHUD

class ViewController: UIViewController {

    func getJsonDataFromName(name: String) -> [Any] {
        let asset = NSDataAsset(name: name, bundle: Bundle.main)
        return try! JSONSerialization.jsonObject(with: asset!.data, options: []) as! [Any]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        SVProgressHUD.show()
        //Time consuming task here
        let asset = NSDataAsset(name: "categories", bundle: Bundle.main)
        let json = try? JSONSerialization.jsonObject(with: asset!.data, options: [])
        RecipeManager.LoadAllCategories(jsonWithArrayRoot: getJsonDataFromName(name: "categories"))
        RecipeManager.LoadAllRecipes(jsonWithArrayRoot: getJsonDataFromName(name: "recipes"))
        self.performSegue(withIdentifier: "goToTabBar", sender: self)
        SVProgressHUD.dismiss()
    }

}


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

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        SVProgressHUD.show()
        
        let url = URL(string: "http://vnbsoft.ddns.net:1234/api/Recipe?category")
        HttpHelperRequest.FetchHttpGet(with: url, completionHandler: { (data, response, error) in
            if let jsonData = data
            {
                // Will return an object or nil if JSON decoding fails
                do
                {
                    let message = try JSONSerialization.jsonObject(with: jsonData, options:.mutableContainers)
                    if let jsonResult = message as? NSMutableArray
                    {
                        for anyObj in jsonResult as Array<AnyObject>
                        {
                            
                            var id : Int = (anyObj["Id"] as AnyObject? as? Int) ?? 0
                            var bgImg:String = (anyObj["BgImageUrl"] as AnyObject? as? String) ?? ""
                            var categoryName:String = (anyObj["CategoryName"] as AnyObject? as? String) ?? ""
                            var totalOfRecipes : Int = (anyObj["TotalOfRecipes"] as AnyObject? as? Int) ?? 0
                            
                            var category:Category = Category(id: id, categoryName: categoryName, bgImg: bgImg, totalOfRecipes: totalOfRecipes);
                            
                            Category.Instance?.append(category);
                        }
                        
                        //return jsonResult //Will return the json array output
                    }
                }
                catch let error as NSError
                {
                    print("An error occurred: \(error)")
                }
            }
            self.performSegue(withIdentifier: "goToTabBar", sender: self)
            SVProgressHUD.dismiss()
        })
    }

}


//
//  RecipeDetailViewController.swift
//  RecipeFoodTest
//
//  Created by TienPV on 12/7/18.
//  Copyright © 2018 TienPV. All rights reserved.
//

import UIKit
import SVProgressHUD



class RecipeDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    var previewImage:String?
    var name:String?
    var difficult:String?
    var nbReverving:Int?
    var content:String?
    var imageLink:String?
    var recipeArray:Array<String>?
    var summary:String?
    var lstImage:Array<Array<String>>! = Array<Array<String>>()
    var resourceImageLst : Dictionary<Int, UIImage> = Dictionary<Int, UIImage>()
    var lstContent:Array<String>?
    
    var isLoaded:Bool! = false
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleNavigationITem: UINavigationItem!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        SVProgressHUD.show()
        isLoaded = false
        
        self.titleNavigationITem.title = "";
        self.lstContent = Array<String>()
        self.lstImage = Array<Array<String>>()
        
        let URLStr = "http://vnbsoft.ddns.net:1234/api/Recipe?recipeId=" + String(format: "%d", RecipeItem.CurrentRecipeId)
        let url = URL(string: URLStr)
        HttpHelperRequest.FetchHttpGet(with: url, completionHandler: { (data, response, error) in
            if let jsonData = data
            {
                // Will return an object or nil if JSON decoding fails
                do
                {
                    let message = try JSONSerialization.jsonObject(with: jsonData, options:.mutableContainers) as AnyObject
                    
                    self.previewImage = (message["PreviewImage"] as AnyObject? as? String) ?? ""
                    self.name = (message["RecipeName"] as AnyObject? as? String) ?? ""
                    self.difficult = (message["DifficultLevel"] as AnyObject? as? String) ?? ""
                    self.nbReverving = (message["NbReserving"] as AnyObject? as? Int) ?? 0
                    self.content = (message["Content"] as AnyObject? as? String) ?? ""
                    self.imageLink = (message["ImageLink"] as AnyObject? as? String) ?? ""
                    var recipes = (message["Recipes"] as AnyObject? as? String) ?? ""
                    self.recipeArray = recipes.components(separatedBy: ",")
                    self.summary = (message["Summary"] as AnyObject? as? String) ?? ""
                    
                    
                        // Parse images
                    var jsonData2 = self.imageLink!.data(using: .utf8)
                        var message2 = try JSONSerialization.jsonObject(with: jsonData2!, options:.mutableContainers) as AnyObject
                        var jsonContent = message2 as? NSMutableArray
                        for anyObj in jsonContent as! Array<AnyObject>
                        {
                            var imageUrlLst:Array<String> = Array<String>()
                            for anyObj2 in anyObj as! Array<AnyObject>
                            {
                                imageUrlLst.append(anyObj2 as! String)
                            }
                            self.lstImage?.append(imageUrlLst)
                        }
                        
                        // Parse content
                    jsonData2 = self.content!.data(using: .utf8)
                        message2 = try JSONSerialization.jsonObject(with: jsonData2!, options:.mutableContainers) as AnyObject
                        jsonContent = message2 as? NSMutableArray

                        for anyObj in jsonContent as! Array<AnyObject>
                        {
                            self.lstContent?.append(anyObj as! String)
                        }
                    
                    
                    DispatchQueue.main.async {
                        self.titleNavigationITem.title = self.name;
                        self.tableView.reloadData()
                        NSLog("reloadData")
                    }

                }
                catch let error as NSError
                {
                    print("An error occurred: \(error)")
                }
            }
            
            SVProgressHUD.dismiss()
            self.isLoaded = true
            
        })
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.item == 0)
        {
            return 404
        }
        else if (indexPath.item == 1)
        {
            return 52
        }
        else if (indexPath.item > 1 && indexPath.item < 2 + (recipeArray?.count)!)
        {
            return 32
        }
        else if (indexPath.item == 2 + (recipeArray?.count)!)
        {
            return 67
        }
        return 390
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (isLoaded)
        {
            return 3 + (self.recipeArray?.count)! + ((self.lstContent?.count)!)
        }
        else
        {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.item == 0)
        {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "PreviewImg") as! PreviewImgCell
            cell.lblDescription.text = summary
            let url = URL(string: (previewImage!))
            let task = URLSession.shared.dataTask(with: url!) { data, response, error in
                guard let data = data, error == nil else { return }
                
                DispatchQueue.main.async() {
                    cell.previewImg.image = UIImage(data: data)
                }
            }
            task.resume()
        
            return cell
        }
        else if (indexPath.item == 1)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeTitle") as! RecipeTitleCell
            cell.nbReserving.text = String(format:"%d", nbReverving!)
            return cell
        }
        else if (indexPath.item > 1 && indexPath.item < 2 + (recipeArray?.count)!)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell") as! RecipeCell
            cell.lblRecipeName.text = recipeArray![indexPath.item-2].replacingOccurrences(of: "\'", with: "")
            return cell
        }
        else if (indexPath.item == 2 + (recipeArray?.count)!)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeStepTitle") as! RecipeStepTitleCell
            return cell
        }
        else if (indexPath.item > 2 + (recipeArray?.count)!)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeStepCell") as! RecipeStepCell
            cell.lblStepIndex.text = String(format:"%d", indexPath.item - 2 - (recipeArray?.count)!)

            let description = lstContent![indexPath.item - 3 - (recipeArray?.count)!]
            let fromIndex = description.index(description.startIndex, offsetBy: 8)
            
            cell.lblStepDescription.text = description.substring(from: fromIndex)
            
            if self.resourceImageLst[(indexPath.item - 3 - ((recipeArray?.count)!))] == nil
            {
                let url = URL(string: (lstImage[indexPath.item - 3 - (recipeArray?.count)!][0]))
                let task = URLSession.shared.dataTask(with: url!) { data, response, error in
                    guard let data = data, error == nil else { return }
                    
                    DispatchQueue.main.async() {    // execute on main thread
                        cell.BgImageView.image = UIImage(data: data)
                        self.resourceImageLst[(indexPath.item - 3 - (self.recipeArray?.count)!)] = UIImage(data: data)
                    }
                }
                task.resume()
            }
            else
            {
                cell.BgImageView.image = self.resourceImageLst[(indexPath.item - 3 - (recipeArray?.count)!)]
            }
            
            cell.BgImageView.layer.cornerRadius = 8.0
            cell.BgImageView.clipsToBounds = true

            
            return cell
        }
        return UITableViewCell()
    }
    

}

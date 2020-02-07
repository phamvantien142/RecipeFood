//
//  RecipeDetailViewController.swift
//  RecipeFood
//
//  Created by TienPV on 12/7/18.
//  Copyright © 2018 TienPV. All rights reserved.
//

import UIKit

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
        
        self.showSpinner(onView: self.view)
        isLoaded = false
        
        self.titleNavigationITem.title = "";
        self.lstContent = Array<String>()
        self.lstImage = Array<Array<String>>()
        
        DispatchQueue.global(qos: .background).async {
            
            let currentRecipe = RecipeManager.CurrentRecipe
            self.previewImage = currentRecipe?.PreviewImg
            if (!(self.previewImage!.starts(with: "http"))) {
                self.previewImage = "https://media.cooky.vn/" + self.previewImage!
            }
            self.name = currentRecipe?.RecipeName
            self.difficult = currentRecipe?.DifficultLevel
            self.nbReverving = currentRecipe?.NbReserving
            
            RecipeManager.Group.wait()
            for item in RecipeManager.RecipesDetailInstance! {
                if (item.Id == RecipeManager.CurrentRecipe?.Id) {
                    self.content = item.Content
                    self.lstImage = item.ImageLst
                    self.recipeArray = item.RecipeArray
                    self.summary = item.Summary
                    // Will return an object or nil if JSON decoding fails
                    
                    do
                    {
                        // Parse content
                        let jsonData2 = self.content!.data(using: .utf8)
                        let message2 = try JSONSerialization.jsonObject(with: jsonData2!, options:.mutableContainers) as AnyObject

                        for anyObj in message2 as! Array<AnyObject>
                        {
                            self.lstContent?.append(anyObj as! String)
                        }
                    }
                    catch let error as NSError
                    {
                        print("An error occurred: \(error)")
                    }
                    
                    break
                }
            }
            DispatchQueue.main.async {
                self.titleNavigationITem.title = self.name;
                self.tableView.reloadData()
                NSLog("reloadData")
            }
            self.removeSpinner()
            self.isLoaded = true
        }
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
            cell.previewImg.image = LoadingGif
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
            cell.lblRecipeName.text = recipeArray![indexPath.item-2].replacingOccurrences(of: "\"", with: "")
                .replacingOccurrences(of: "\r", with: "")
                .replacingOccurrences(of: "\n", with: "")
            .replacingOccurrences(of: "<sub>", with: "")
            .replacingOccurrences(of: "</sub>", with: "")
            .replacingOccurrences(of: "<sup>", with: "")
            .replacingOccurrences(of: "</sup>", with: "")
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
                let imgArr = lstImage[indexPath.item - 3 - (recipeArray?.count)!]
                if (imgArr.count > 0) {
                    var urlStr = imgArr[0]
                    if (!(urlStr.starts(with: "http"))) {
                        urlStr = "https://media.cooky.vn/" + urlStr
                    }
                    let url = URL(string: urlStr)
                    cell.BgImageView.image = LoadingGif
                    let task = URLSession.shared.dataTask(with: url!) { data, response, error in
                        guard let data = data, error == nil else { return }
                        
                        DispatchQueue.main.async() {    // execute on main thread
                            cell.BgImageView.image = UIImage(data: data)
                            self.resourceImageLst[(indexPath.item - 3 - (self.recipeArray?.count)!)] = UIImage(data: data)
                        }
                    }
                    task.resume()
                }
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

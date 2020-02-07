//
//  RecipeByCategoryViewController.swift
//  RecipeFood
//
//  Created by TienPV on 12/6/18.
//  Copyright © 2018 TienPV. All rights reserved.
//

import UIKit

class RecipeByCategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var lblFoundRecords: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var recipeLst : Array<RecipePreview>? = Array<RecipePreview>()
    var resourceImageLst : Dictionary<String, UIImage> = Dictionary<String, UIImage>()
    var currentPage : Int = 0
    var totalPage : Int = 1
    var totalRecords : Int = 0
    var isPageLoaded : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        isPageLoaded = false
        
        //SVProgressHUD.show()
        searchData(pageIndex: 1)
        
        self.title = RecipeManager.CurrentCategoryName
    }
    
    func searchData(pageIndex : Int!)
    {
        DispatchQueue.global(qos: .background).async {
            var recordItems = Array<RecipePreview>()
            for previewItem in RecipeManager.RecipesPreviewInstance! {
                if (previewItem.CategoryId == RecipeManager.CurrentCategoryId) {
                    recordItems.append(previewItem)
                }
            }
            self.totalRecords = recordItems.count ?? 0
            self.totalPage = self.totalRecords / 15
            if self.totalRecords % 15 > 0
            {
                self.totalPage = self.totalPage + 1
            }
            for id in ((pageIndex - 1) * 15)..<(pageIndex * 15 - 1) {
                if (id >= self.totalRecords) {
                    break
                }
                self.recipeLst?.append(recordItems[id])
            }
            //SVProgressHUD.dismiss()
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.isPageLoaded = false;
                self.lblFoundRecords.text = String(format: "Có %d công thức", self.totalRecords)
                self.lblFoundRecords.isHidden = false
            }
        }
    }
    
    //delegate methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (recipeLst?.count)!
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        RecipeManager.CurrentRecipe = recipeLst?[indexPath.item]
        // goToRecipeList
        performSegue(withIdentifier: "categoryGoToRecipeDetail", sender: self)
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Row") as! SearchTableViewCell
        
        cell.lblSearchTitle.text = recipeLst?[indexPath.item].RecipeName
        cell.lblSearchNbReserving.text = String(format: "%d", recipeLst?[indexPath.item].NbReserving ?? 0)
        cell.lblSearchLevel.text = recipeLst?[indexPath.item].DifficultLevel
        var urlStr = recipeLst?[indexPath.item].PreviewImg!
        if (!(urlStr?.starts(with: "http"))!) {
            urlStr = "https://media.cooky.vn/" + urlStr!
        }
        let url = URL(string: (urlStr!))
        //let data = try? Data(contentsOf: url!)
        //cell.previewImage.image = UIImage(data: data!)
        if (self.resourceImageLst[(recipeLst?[indexPath.item].RecipeName)!] == nil)
        {
            cell.previewImage.setLoadingAnimation()
            let task = URLSession.shared.dataTask(with: url!) { data, response, error in
                guard let data = data, error == nil else { return }
                
                DispatchQueue.main.async() {    // execute on main thread
                    let image = UIImage(data: data)
                    cell.previewImage.setImage(image: image!)
                    self.resourceImageLst[(self.recipeLst?[indexPath.item].RecipeName)!] = UIImage(data: data)
                }
            }
            task.resume()
        }
        else
        {
            cell.previewImage.image = self.resourceImageLst[(recipeLst?[indexPath.item].RecipeName)!]
        }
        
        cell.previewImage.layer.cornerRadius = 8.0
        cell.previewImage.clipsToBounds = true
        cell.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        cell.layer.borderWidth = 2
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let isReachingEnd = scrollView.contentOffset.y >= 0
            && scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)
        
        if isReachingEnd && totalPage > currentPage && !isPageLoaded
        {
            isPageLoaded = true;
            currentPage = currentPage + 1
            searchData(pageIndex: currentPage)
            NSLog("Scroll end!!!")
        }
    }

}

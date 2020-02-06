//
//  Category.swift
//  RecipeFoodTest
//
//  Created by TienPV on 12/5/18.
//  Copyright © 2018 TienPV. All rights reserved.
//

import UIKit
import SVProgressHUD

class SearchController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate
{
    
    @IBOutlet weak var lblFoundRecords: UILabel!
    @IBOutlet weak var NotFoundView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    
    var recipeLst : Array<RecipePreview>? = Array<RecipePreview>()
    var resourceImageLst : Dictionary<Int, UIImage> = Dictionary<Int, UIImage>()
    var currentPage : Int = 0
    var totalPage : Int = 1
    var totalRecords : Int = 0
    var isPageLoaded : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        NotFoundView.isHidden = true;
        lblFoundRecords.isHidden = true;
        isPageLoaded = false
        
        self.title = "Tìm kiếm"
        self.parent?.title = "Tìm kiếm"
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tabBarController?.navigationItem.title = "Tìm kiếm"
    }
    

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if (searchBar.text != "")
        {
            NSLog(searchBar.text!)
            searchBar.endEditing(true)
            
            SVProgressHUD.show()
            NotFoundView.isHidden = true;
            lblFoundRecords.isHidden = true;
            tableView.setContentOffset(.zero, animated:true)
            recipeLst?.removeAll()
            tableView.reloadData()

            
            currentPage = 1
            self.totalRecords = 0
            
            searchData(pageIndex: 1)
        }
    }
    
    func searchData(pageIndex : Int!)
    {
        var keyParams = searchBar.text?.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        let URLStr = "http://vnbsoft.ddns.net:1234/api/Recipe?key=" + keyParams! + "&pageIndex=" + String(format: "%d", pageIndex)
        let url = URL(string: URLStr)
        HttpHelperRequest.FetchHttpGet(with: url, completionHandler: { (data, response, error) in
            if let jsonData = data
            {
                // Will return an object or nil if JSON decoding fails
                do
                {
                    let message = try JSONSerialization.jsonObject(with: jsonData, options:.mutableContainers) as AnyObject
                    self.totalRecords = (message["Key"] as AnyObject? as? Int) ?? 0
                    self.totalPage = self.totalRecords / 15;
                    if self.totalRecords % 15 > 0
                    {
                        self.totalPage = self.totalPage + 1
                    }
                    
                    if let jsonResult = message["Value"] as? NSMutableArray
                    {
                        var id : Int = 0
                        for anyObj in jsonResult as Array<AnyObject>
                        {
                            
                            var id : Int = (anyObj["Id"] as AnyObject? as? Int) ?? 0
                            var previewImage:String = (anyObj["PreviewImage"] as AnyObject? as? String) ?? ""
                            var name:String = (anyObj["RecipeName"] as AnyObject? as? String) ?? ""
                            var difficult:String = (anyObj["DifficultLevel"] as AnyObject? as? String) ?? ""
                            var nbReverving : Int = (anyObj["NbReserving"] as AnyObject? as? Int) ?? 0
                            
                            /*
                            var recipeItem:RecipePreview = RecipePreview(id: id, previewImg: previewImage,name: name, difficult : difficult, nbReserving: nbReverving)
                            
                            self.recipeLst?.append(recipeItem);
                            */
                            
                        }
                        
                        //return jsonResult //Will return the json array output
                    }
                }
                catch let error as NSError
                {
                    print("An error occurred: \(error)")
                }
            }
            
            SVProgressHUD.dismiss()
            
            DispatchQueue.main.async {
                if self.recipeLst?.count == 0
                {
                    self.NotFoundView.isHidden = false;
                }
                else
                {
                    self.tableView.reloadData()
                }
                
                self.isPageLoaded = false;
                self.lblFoundRecords.text = String(format: "Tìm thấy %d kết quả", self.totalRecords)
                self.lblFoundRecords.isHidden = false
            }
            
        })
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
        RecipeItem.CurrentRecipeId = recipeLst?[indexPath.item].Id ?? -1
        // goToRecipeList
        performSegue(withIdentifier: "searchGoToRecipeDetail", sender: self)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Row") as! SearchTableViewCell
        
        cell.lblSearchTitle.text = recipeLst?[indexPath.item].RecipeName
        cell.lblSearchNbReserving.text = String(format: "%d", recipeLst?[indexPath.item].NbReserving ?? 0)
        cell.lblSearchLevel.text = recipeLst?[indexPath.item].DifficultLevel
        let url = URL(string: (recipeLst?[indexPath.item].PreviewImg)!)
        //let data = try? Data(contentsOf: url!)
        //cell.previewImage.image = UIImage(data: data!)
        if self.resourceImageLst[(recipeLst?[indexPath.item].Id)!] == nil
        {
            let task = URLSession.shared.dataTask(with: url!) { data, response, error in
                guard let data = data, error == nil else { return }
                
                DispatchQueue.main.async() {    // execute on main thread
                    cell.previewImage.image = UIImage(data: data)
                    self.resourceImageLst[(self.recipeLst?[indexPath.item].Id)!] = UIImage(data: data)
                }
            }
            task.resume()
        }
        else
        {
            cell.previewImage.image = self.resourceImageLst[(recipeLst?[indexPath.item].Id)!]
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

//
//  Category.swift
//  RecipeFood
//
//  Created by TienPV on 12/5/18.
//  Copyright © 2018 TienPV. All rights reserved.
//

import UIKit

class CategoryController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    @IBOutlet weak var collectionView: UICollectionView!
    var resourceImageLst : Dictionary<Int, UIImage> = Dictionary<Int, UIImage>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self;
        collectionView.delegate = self;
        
        self.title = "Trang chủ"
        self.parent?.title = "Trang chủ" 
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tabBarController?.navigationItem.title = "Trang chủ"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        RecipeManager.CurrentCategoryId = RecipeManager.CategoriesInstance?[indexPath.item].Id ?? -1
        RecipeManager.CurrentCategoryName = RecipeManager.CategoriesInstance?[indexPath.item].CategoryName ?? ""
        // goToRecipeList
        performSegue(withIdentifier: "goToRecipeList", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section : Int) -> Int {
        return (RecipeManager.CategoriesInstance?.count)!;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CategoryCollectionViewCell
        let categoryItem = RecipeManager.CategoriesInstance?[indexPath.item]
        cell.lblTitle.text = categoryItem?.CategoryName
        cell.lblDescription.text = String(format: "(%d món)", RecipeManager.CategoryCounter![categoryItem!.Id] ?? 0)
        let url = URL(string: (categoryItem!.BgImg)!)
        //let data = try? Data(contentsOf: url!)
        //cell.previewImage.image = UIImage(data: data!)
        if self.resourceImageLst[(categoryItem!.Id)!] == nil
        {
            let task = URLSession.shared.dataTask(with: url!) { data, response, error in
                guard let data = data, error == nil else { return }
                
                DispatchQueue.main.async() {    // execute on main thread
                    cell.previewImage.image = UIImage(data: data)
                    self.resourceImageLst[(RecipeManager.CategoriesInstance?[indexPath.item].Id)!] = UIImage(data: data)
                }
            }
            task.resume()
        }
        else
        {
            cell.previewImage.image = self.resourceImageLst[(RecipeManager.CategoriesInstance?[indexPath.item].Id)!]
        }
        
        cell.previewImage.layer.cornerRadius = 8.0
        cell.previewImage.clipsToBounds = true
       
        return cell
    }
    

}

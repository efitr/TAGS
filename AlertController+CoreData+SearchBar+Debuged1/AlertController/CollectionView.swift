//
//  CollectionView.swift
//  AlertController
//
//  Created by Egon Fiedler on 7/29/17.
//  Copyright © 2017 App Solutions. All rights reserved.
//

import Foundation
import UIKit


class CollectionView: UIViewController, UISearchBarDelegate
{
    
    var initialDataAry:[TagedPhoto] = CoreDataHelper.retrievetagedPhoto()
    var tagedPhotos:[TagedPhoto] = CoreDataHelper.retrievetagedPhoto()
    {
        didSet {
            collectionView.reloadData()
        }
    }

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    func searchBarSetup() {
        searchBar.delegate = self
    }
    
    // MARK: - search bar delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            tagedPhotos = initialDataAry
            self.collectionView.reloadData()
        }else {
            filterTableView(text: searchText.lowercased())
        }
    }
    
    func filterTableView(text:String) {
            tagedPhotos = initialDataAry.filter({ (tagedPhoto) -> Bool in
                return tagedPhoto.tags.map({$0.lowercased()}).contains(where: {$0.contains(text)})
            })
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        UIApplication.shared.statusBarStyle = .lightContent
        
        initialDataAry = CoreDataHelper.retrievetagedPhoto()
        tagedPhotos = CoreDataHelper.retrievetagedPhoto()
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        searchBarSetup()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "addImage"
        {
            print("Agregando una imagen")
        }
        else if segue.identifier == "seeImage"
        {
            let destination = segue.destination as! PhotoPickerTableAlert
            let indexOfRow = collectionView.indexPathsForSelectedItems?[0].row
            destination.tagedPhotoBeingPassedIn = tagedPhotos[indexOfRow!]
        }
    }
    @IBAction func unwindToCollectionView(_ segue: UIStoryboardSegue)
    {
        
    }
}


extension CollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    //Specifying the number of cells in the given section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        print(tagedPhotos.count)
        return tagedPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {   //since its cheaper and faster to reuse a cell, compared to making a new one, here is that capacity
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  "collectionCell", for: indexPath) as! CollectionViewCell
        let tagedPhoto = tagedPhotos[indexPath.row]
        cell.deletePhoto = { [weak self] (tagPhoto) in
            CoreDataHelper.delete(tagedPhoto: tagPhoto)
            CoreDataHelper.saveTagedPhoto()
            self?.tagedPhotos = CoreDataHelper.retrievetagedPhoto()
        }
        cell.taggedPhoto = tagedPhoto
        guard let safeImage = tagedPhoto.photo else{
            return cell
        }
        
        cell.image.image = UIImage(data:safeImage as Data,scale:0.3)
        return cell //it now returns a cell with all the above characteristics
    }
    
    //Size of the cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
//        var layout = UICollectionViewFlowLayout() // lets you custumize how your layot is going to look, 4:10 cuenta algo mas de esto
//        layout.minimumLineSpacing = 0 //esta haciendo que el espacio entre rows of cell, que sea 0
//        layout.minimumInteritemSpacing = 0 //como las collectionViews se establecen aca, esta haciendo que el espacio entre items sea 0
//        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout )
        return CGSize(width: 110, height: 110)
    }
}



//
//  PhotoPickerTableAlert.swift
//  AlertController
//
//  Created by Egon Fiedler on 7/29/17.
//  Copyright © 2017 App Solutions. All rights reserved.
//

import Foundation
import UIKit
//Foundation for a complete app
//Add an easy way to submit photos to social media
//Need some way to be able to tap a photo and see it full screen or be able to open it up in the photos app
//Need to store a reference to the the image, not the image. The stackoverflow answers show how to do this

//Update
//get all the pictures from the laptop to the phone

class PhotoPickerTableAlert: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var tagedPhotoBeingPassedIn: TagedPhoto?    //a variable to hold a TagedPhoto, a Array of tags and a photo ImageView
    var tagArray: [String] = []                //an array to hold the values for the Array of tags
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBAction func chooseImage(_ sender: Any)
    {   //setting the imagePicker and its delegate, the let imagePickerController inherits from UIImagePickerController and sets that its properties will be executed by him
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        //Creating the constant actionSheel and having it inherit from UIAlertController
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        //setting the camara function
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera)
            {
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)//setting the animation
                
            } else
            {
                print("Camera not available")
            }
        }))
        //setting the library functionality, so you can accesses it
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {(action: UIAlertAction) in
                imagePickerController.sourceType = .photoLibrary
                self.present(imagePickerController, animated: true, completion: nil)//setting the animation
        }))
        //The capacity to cancel so you dont get stuck
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(actionSheet, animated: true, completion: nil)//setting the animation
    }
    
    //Este metodo se encarga de recibir la imagen una vez este acabado el proceso de seleccion
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {   //la imagen que recibio del metodo es typecast de UIImagePickerControllerOriginalImage a UIImage para que sea usable
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        //Se usa la constante image, para que tenga la data del imageView del interface, asi siendo esta de tipo image, sera la misma que la recogida por photoPicker
        self.imageView.image = image
        picker.dismiss(animated: true, completion: nil) //Cancelacion de la animacion previamente establecida
    }
    
    //Esta funcion se activa en caso halla habido una cancelacion
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        picker.dismiss(animated: true, completion: nil) //Cancelacion de la animacion previamente establecida
    }
    
    //This is called by the system itself in case of low memory
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    //This method is to load the image for viewWillAppear
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //estamos explicitamente unwrapping una imagen, por eso crashea, necesitamos hacerl oseguro
        
        if tagedPhotoBeingPassedIn != nil
        {
            imageView.image = UIImage(data:tagedPhotoBeingPassedIn!.photo! as Data, scale:1.0)
            tableView.reloadData()
        }
        
        //there is an error in this part, the logic after the last fixes fell apart
        //ACA
        //ACA
        //ACA
    }

    //This keeps the image in place
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        //This is to show the image itself
        guard tagedPhotoBeingPassedIn != nil else {
            return
        }
        if let taggedPhoto = tagedPhotoBeingPassedIn{
            tagArray = taggedPhoto.tags
        }
        else{
            tagArray = []
        }
    }
    
    @IBAction func saveClicked(_ sender: Any) {
        guard let _ = imageView.image else {
            return
        }
        
        performSegue(withIdentifier: "Save", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        guard var image = imageView.image else {
            return
        }
        //should work with the possibility of pressing save without something stored, and getting nothing
        //could the above question lay in another if statement dentro de este if statement
        let destination = segue.destination as! CollectionView
        //let destination = "Hello World" as! CollectionView
        
        //the code below creates a new image and adds it to the images array for the colleciton view
        //BUT you only want it to create a new image if you're not editing a current one
        
        image = PhotoPickerTableAlert.fixOrientation(img: image)
        
        if let taggedPhoto = tagedPhotoBeingPassedIn{
            taggedPhoto.photo = UIImagePNGRepresentation(image)! as NSData
            taggedPhoto.tags = tagArray
        }
        else{
            let tagedPhoto = CoreDataHelper.newTagedPhoto()
            
            tagedPhoto.photo = UIImagePNGRepresentation(image)! as NSData
            tagedPhoto.tags = tagArray
        }
        
        
        
        
        CoreDataHelper.saveTagedPhoto()

            
//        destination.tagedPhotos.append(tagedPhoto)

    }
    
    static func fixOrientation(img:UIImage) -> UIImage {
        
        if (img.imageOrientation == UIImageOrientation.up) {
            return img;
        }
        
        UIGraphicsBeginImageContextWithOptions(img.size, false, img.scale);
        let rect = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
        img.draw(in: rect)
        
        let normalizedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext();
        return normalizedImage;
        
    }
}

extension PhotoPickerTableAlert: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // #warning Incomplete implementation, return the number of rows
        
//        if tagedPhotoBeingPassedIn != nil
//        {
//            return tagedPhotoBeingPassedIn!.tags.count
//        }

        return tagArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let currentCell = tableView.dequeueReusableCell(withIdentifier: "tagCell", for: indexPath) as! TableViewCell
        
//        if tagedPhotoBeingPassedIn != nil
//        {
//            currentCell.tagLabel.text = tagedPhotoBeingPassedIn!.tags[indexPath.row]
//        }
//        else
//        {
            currentCell.tagLabel.text = tagArray[indexPath.row]
        //}
        
        return currentCell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            tagArray.remove(at: indexPath.row)
            tableView.reloadData()
//            CoreDataHelper.delete(tagedPhoto: tagArray[indexPath.row] as! TagedPhoto)
//            tagArray = CoreDataHelper.retrievetagedPhoto()
        }
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Add a tag", message: "This is where you add a new tag", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: {
            alert -> Void in
            
            let textField = alertController.textFields![0] as UITextField
            
            if let theText = textField.text, theText != ""
            {
                self.tagArray.append(theText)
                
                self.tableView.reloadData()
            }
            else
            {
                print("You didn't input anything")
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { alert -> Void in
            print("Canceled")
            
        })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Your Subject"
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
    
        self.present(alertController, animated: true, completion: nil)
    }
}

//
//  UploadViewController.swift
//  YOS
//
//  Created by Zhongtian Chen on 10/19/16.
//  Copyright © 2016 University High School. All rights reserved.
//

import UIKit
import Photos
import FirebaseAuth
import FirebaseStorage
import QBImagePickerController

class UploadViewController: UIViewController, QBImagePickerControllerDelegate {

    let imageManager : PHImageManager = PHImageManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func choosePressed(_ sender: UIButton) {
        let imagePickerVC : QBImagePickerController = QBImagePickerController()
        imagePickerVC.delegate = self
        imagePickerVC.allowsMultipleSelection = true
        imagePickerVC.showsNumberOfSelectedAssets = true
        self.present(imagePickerVC, animated: true, completion: nil)
    }

    func qb_imagePickerController(_ imagePickerController: QBImagePickerController!, didFinishPickingAssets assets: [Any]!) {
        self.dismiss(animated: true, completion: nil)
        for asset in assets as! [PHAsset] {
            if asset.mediaType == .image {
                uploadImageAsset(asset: asset)
            }
        }
    }
    
    func qb_imagePickerControllerDidCancel(_ imagePickerController: QBImagePickerController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func uploadImageAsset(asset : PHAsset) {
        let uid = FIRAuth.auth()?.currentUser?.uid
        let imageName : String = uid! + "\(Int(NSDate().timeIntervalSince1970*100000))"
        NSLog("ImageName: \(imageName)")
        let imagesRef = FIRStorage.storage().reference(forURL: "gs://yosdatacollection.appspot.com").child("images/\(imageName)")
        
        
        
        imageManager.requestImageData(for: asset, options: nil) { (imageData, dataUTI, orientation, info) in
            if let imageData = imageData {
                let metadata : FIRStorageMetadata = FIRStorageMetadata()
                metadata.contentType = "image/jpeg"
                let uploadTask = imagesRef.put(imageData, metadata: metadata) { metadata, error in
                    if let error = error {
                        NSLog("Error uploading image to Storage: \(error)")
                    }
                }
                uploadTask.observe(.progress, handler: { (snapshot) in
                    NSLog("\(snapshot.progress!.fractionCompleted)")
                })
            } else {
                NSLog("Error getting image data!")
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

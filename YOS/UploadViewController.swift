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

    @IBOutlet weak var progressView: UIProgressView!
    
    let imageManager : PHImageManager = PHImageManager()
    var percentCompletions : [Double]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressView.progress = 0
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
        imagePickerVC.mediaType = .image
        self.present(imagePickerVC, animated: true, completion: nil)
    }

    func qb_imagePickerController(_ imagePickerController: QBImagePickerController!, didFinishPickingAssets assets: [Any]!) {
        self.dismiss(animated: true, completion: nil)
        percentCompletions = []
        for i in 0..<assets.count {
            let asset = assets[i] as! PHAsset
            if asset.mediaType == .image {
                let uid = FIRAuth.auth()?.currentUser?.uid
                let imageName : String = uid! + "+\(Int(NSDate().timeIntervalSince1970*100000))"
                let imagesRef = FIRStorage.storage().reference(forURL: "gs://yosdatacollection.appspot.com").child("images/\(imageName)")
                
                
                
                imageManager.requestImageData(for: asset, options: nil) { (imageData, dataUTI, orientation, info) in
                    if let imageData = imageData {
                        let metadata : FIRStorageMetadata = FIRStorageMetadata()
                        metadata.contentType = "image/jpeg"
                        let uploadTask = imagesRef.put(imageData, metadata: metadata) { metadata, error in
                            if let error = error {
                                NSLog("Error uploading image to Storage: \(error)")
                            } else {
                                self.percentCompletions[i] = 1.0
                                self.updateProgress()
                            }
                        }
                        self.percentCompletions.insert(0, at: i)
                        uploadTask.observe(.progress, handler: { (snapshot) in
                            self.percentCompletions[i] = snapshot.progress!.fractionCompleted
                            self.updateProgress()
                        })
                    } else {
                        NSLog("Error getting image data!")
                    }
                }
            }
        }
    }
    
    func qb_imagePickerControllerDidCancel(_ imagePickerController: QBImagePickerController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func updateProgress() {
        progressView.progress = Float(percentCompletions.average)
        NSLog("verification: \(progressView.progress), \(dump(percentCompletions))")
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

extension Array where Element: FloatingPoint {
    /// Returns the sum of all elements in the array
    var total: Element {
        return reduce(0, +)
    }
    /// Returns the average of all elements in the array
    var average: Element {
        return isEmpty ? 0 : total / Element(count)
    }
}

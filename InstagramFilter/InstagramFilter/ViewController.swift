//
//  ViewController.swift
//  InstagramFilter
//
//  Created by James Fong on 2018-01-05.
//  Copyright © 2018 James Fong. All rights reserved.
//

import UIKit
import AVKit
import Photos

class ViewController: UIViewController {

    var imgPickerViewController: UIImagePickerController!
    override func viewDidLoad() {
        super.viewDidLoad()
        imgPickerViewController = UIImagePickerController()
        imgPickerViewController.delegate = self
        imgPickerViewController.mediaTypes = ["public.image", "public.movie"]
        imgPickerViewController.allowsEditing = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func importFromGallery(_ sender: Any) {
        imgPickerViewController.sourceType = .photoLibrary
        present(imgPickerViewController, animated: true, completion: nil)
    }
    
    @IBAction func importFromCamera(_ sender: Any) {
        imgPickerViewController.sourceType = .camera
        present(imgPickerViewController, animated: true, completion: nil)
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            let imgViewController = FilterImageViewController(image:image)
            imgViewController.delegate = self
            self.present(imgViewController, animated: false, completion: nil)
            
        }
        else {
            if let nsURL = info[UIImagePickerControllerMediaURL] as? NSURL {
                let video = AVURLAsset(url: nsURL.absoluteURL!)
                let videoViewController = FilterVideoViewController(video:video)
                videoViewController.delegate = self
                self.present(videoViewController, animated: false, completion: nil)
            }
            
        }
    }
}

extension ViewController: FilterImageViewControllerDelegate, FilterVideoViewControllerDelegate {
    func filterVideoViewControllerVideoDidFilter(image: UIImage) {
    }
    
    func filterImageViewControllerImageDidFilter(image: UIImage) {
        
    }
    
    func filterImageViewControllerDidCancel() {
        
    }
    
    func filterVideoViewControllerDidCancel() {
        
    }
    
    
}


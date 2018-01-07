//
//  FilterImageViewController.swift
//  InstagramFilter
//
//  Created by James Fong on 2018-01-05.
//  Copyright © 2018 James Fong. All rights reserved.
//

import UIKit

public protocol FilterImageViewControllerDelegate {
    func filterImageViewControllerImageDidFilter(image: UIImage)
    func filterImageViewControllerDidCancel()
}

class FilterImageViewController: FiilterViewController {

    public var delegate: FilterImageViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    public init(image: UIImage) {
        super.init(nibName: nil, bundle: nil)
        self.image = image
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override open func loadView() {
        if let view = UINib(nibName: "FilterImageViewController", bundle: Bundle(for: self.classForCoder)).instantiate(withOwner: self, options: nil).first as? UIView {
            self.view = view
            if let image = self.image {
                imageView?.image = image
                smallImage = resizeImage(image: image)
            }
        }
    }
    
    override func createFilteredImage(filterName: String, image: UIImage) -> UIImage {
        // 1 - create source image
        let sourceImage = CIImage(image: image)
        
        // 2 - create filter using name
        let filter = CIFilter(name: filterName)
        filter?.setDefaults()
        
        // 3 - set source image
        filter?.setValue(sourceImage, forKey: kCIInputImageKey)
        
        // 4 - output filtered image as cgImage with dimension.
        let outputCGImage = context.createCGImage((filter?.outputImage!)!, from: (filter?.outputImage!.extent)!)
        
        // 5 - convert filtered CGImage to UIImage
        let filteredImage = UIImage(cgImage: outputCGImage!, scale: image.scale, orientation: image.imageOrientation)
        
        return filteredImage
    }
    
    @IBAction func closeButtonTapped() {
        if let delegate = self.delegate {
            delegate.filterImageViewControllerDidCancel()
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtontapped() {
        if let delegate = self.delegate {
            delegate.filterImageViewControllerImageDidFilter(image: (imageView?.image)!)
        }
       dismiss(animated: true, completion: nil)
    }
}

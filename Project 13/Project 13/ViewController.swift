//
//  ViewController.swift
//  Project 13
//
//  Created by Alvaro Orellana on 08-09-21.
//

import UIKit
import CoreImage


class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var intensity: UISlider!
    var selectedImage: UIImage!
    var context: CIContext!
    var currentFilter: CIFilter!
    let filerNames = ["CIBumpDistortion", "CIGaussianBlur", "CIPixellate", "CISepiaTone", "CITwirlDistortion", "CIUnsharpMask", "CIVignette"]

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Instafilter"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
        context = CIContext()
        currentFilter = CIFilter(name: "CISepiaTone")
    }

    
    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    
    @IBAction func changeFilter(_ sender: UIButton) {
        let ac = UIAlertController(title: "Choose filter", message: nil, preferredStyle: .actionSheet)
  
        ac.addAction(UIAlertAction(title: "CIBumpDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIGaussianBlur", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIPixellate", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CISepiaTone", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CITwirlDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIUnsharpMask", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIVignette", style: .default, handler: setFilter))
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    
    func setFilter(action: UIAlertAction) {
        // make sure we have a valid image
        guard selectedImage != nil else {
            print("Exiting set filter function")
            return
        }

        // safely read the alert action's title
        guard let actionTitle = action.title else { return }

        currentFilter = CIFilter(name: actionTitle)
        currentFilter.setValue(CIImage(image: selectedImage), forKey: kCIInputImageKey) // Set up the filter with selected image
        applyProccessing()
    }
    
    
    @IBAction func save(_ sender: UIButton) {
    
    }
    
    
    @IBAction func instensityChanged(_ sender: UISlider) {
        applyProccessing()
    }
    
    
    // This is called when an image is imported or when the slider moves
    private func applyProccessing() {
        guard let currentFilterImg = currentFilter.outputImage else { return }
        
        let inputKeys = currentFilter.inputKeys
        
        // Set up filter with corresponding values and keys
        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(intensity.value, forKey: kCIInputIntensityKey)
        }
        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(intensity.value * 200, forKey: kCIInputRadiusKey)
        }
        if inputKeys.contains(kCIInputScaleKey) {
            currentFilter.setValue(intensity.value * 10, forKey: kCIInputScaleKey)
        }
        if inputKeys.contains(kCIInputCenterKey) {
            currentFilter.setValue(CIVector(x: selectedImage.size.width / 2, y: selectedImage.size.height / 2), forKey: kCIInputCenterKey)
        }
        
        // Transfrom CIImage to CGImage
        if let cgImage = context.createCGImage(currentFilterImg, from: currentFilterImg.extent) {
            
            // Transform CGImage to UIImage
            let processedImage = UIImage(cgImage: cgImage)
            imageView.image = processedImage
        }
    }
    
}



// MARK: - ImagePickerController Delegate
extension ViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else { return }
        dismiss(animated: true)
        selectedImage = image
        
        currentFilter.setValue(CIImage(image: selectedImage), forKey: kCIInputImageKey) // Set up the filter with selected image
        applyProccessing()
    }
}

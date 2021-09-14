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
    @IBOutlet weak var intensitySlider: UISlider!
    @IBOutlet weak var radiusSlider: UISlider!
    @IBOutlet weak var scaleSlider: UISlider!
    @IBOutlet weak var changeFilterButton: UIButton!
    
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
        
        // Add all the filter names as actions with same handler
        for filterName in filerNames {
            ac.addAction(UIAlertAction(title: filterName, style: .default, handler: setFilter))
        }
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    
    func setFilter(action: UIAlertAction) {
        // make sure to have a valid image and safely read the alert action's title
        guard let actionTitle = action.title, selectedImage != nil else {
            print("Exiting set filter function check that conditions are met")
            return
        }
        changeFilterButton.setTitle(actionTitle, for: .normal)
        currentFilter = CIFilter(name: actionTitle)
        currentFilter.setValue(CIImage(image: selectedImage), forKey: kCIInputImageKey) // Set up the filter with selected image
        resetSliders()
        applyProccessing()
    }
        
    
    private func resetSliders() {
        intensitySlider.value = 0.5
        radiusSlider.value = 0.5
        scaleSlider.value = 0.5
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
            currentFilter.setValue(intensitySlider.value, forKey: kCIInputIntensityKey)
        }
        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(radiusSlider.value * 200, forKey: kCIInputRadiusKey)
        }
        if inputKeys.contains(kCIInputScaleKey) {
            currentFilter.setValue(scaleSlider.value * 10, forKey: kCIInputScaleKey)
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
    
    
    
    @IBAction func save(_ sender: UIButton) {
        guard let image = imageView.image else {
            AlertControllerHelper.presentAlert(title: "Select an image", message: "You have to select an image first if you want to save it", presenter: self)
            return
            
        }

        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        let alertTitle: String
        let alertMessage: String
        
        if let error = error {
            alertTitle = "Saving error"
            alertMessage = error.localizedDescription
       
        } else {
            alertTitle = "Saved"
            alertMessage = "Image saved to photo library"
        }
        
        
        AlertControllerHelper.presentAlert(title: alertTitle, message: alertMessage, presenter: self)
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

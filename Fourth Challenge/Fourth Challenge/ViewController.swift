//
//  ViewController.swift
//  Fourth Challenge
//
//  Created by Alvaro Orellana on 03-09-21.
//

import UIKit

class ViewController: UITableViewController {
    
    var photos: [Photo] = [] {
        didSet {
            saveToUserDefaults()
            tableView.reloadData()
        }
    }
    
    let userDefaultsKey = "photo_key"
    var selectedImage: UIImage!
    var isEditingMode: Bool = false

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(presentPickerController))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(toggleEditMode))
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadPhotos()
    }
    
    
    
    private func loadPhotos() {
        let defaults = UserDefaults.standard
                
        if let data = defaults.data(forKey: userDefaultsKey) {
            let decoder = JSONDecoder()
           
            do {
                photos = try decoder.decode([Photo].self, from: data)
           
            } catch {
                print("couldn't decode photos from data")
                print(error)
            }
       
        } else {
            presentAlertController(title: "No photos found", message: "Couldn't find any saved photos in this phone")
        }
    }

    
    private func presentAlertController(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default)
        alertVC.addAction(action)
        present(alertVC, animated: true)
    }
    
    
    @objc func presentPickerController() {
        // Configure and present picker controller
        let pickerVC = UIImagePickerController()
        pickerVC.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            pickerVC.sourceType = .camera
       
        } else {
            pickerVC.sourceType = .photoLibrary
            pickerVC.allowsEditing = true
        }
        
        present(pickerVC, animated: true)
    }
    
    
    @objc func toggleEditMode() {
        isEditingMode.toggle()
        
        let barButtonImage: UIBarButtonItem.SystemItem = isEditingMode ? .done : .edit
        title = isEditingMode ? "Edit photo caption" : "4º Challenge"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: barButtonImage, target: self, action: #selector(toggleEditMode))
    }

}



// MARK: - UITableView's data source and delegate
extension ViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let photo = photos[indexPath.row]
        cell.textLabel?.text = photo.caption
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Presents alert controller to add caption to photo row

        if isEditingMode {
            var selectedPhoto = photos[indexPath.row]
           
            // Create alert controller
            let alert = UIAlertController(title: "Add a caption", message: "Write a caption to your photo", preferredStyle: .alert)
            alert.addTextField()
            
            // Create actions
            let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
                let newCaption = alert.textFields![0].text ?? "no caption"
                selectedPhoto.caption = newCaption
                self.photos[indexPath.row] = selectedPhoto
            }
            let cancelAction = UIAlertAction(title: "cancel", style: .destructive)
            
            // Add actions to controller
            alert.addAction(okAction)
            alert.addAction(cancelAction)
           
            // Present it
            present(alert, animated: true)
            
        } else {
            presentDetailViewController(at: indexPath)
        }
    }
    
    
    private func presentDetailViewController(at indexPath: IndexPath) {
        let detailVC = storyboard?.instantiateViewController(identifier: "detailVC") as! DetailViewController
        detailVC.setUp(title: "Image \(indexPath.row + 1) out of \(photos.count)", imageFileName: photos[indexPath.row].fileName)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
}



// MARK: - UIImagePickerControllerDelegate
extension ViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if picker.sourceType == .camera {
            if let image = info[.originalImage] as? UIImage {
                saveImage(image)
            }
       
        } else if picker.sourceType == .photoLibrary {
            if let image = info[.editedImage] as? UIImage {
                saveImage(image)
            }
        }
        dismiss(animated: true)
    }
    
}



// MARK: - File system functions
extension ViewController {
    
    func saveImage(_ image: UIImage) {
        if let imageData = image.pngData() {
            
            let photo = Photo(fileName: UUID().uuidString, caption: "No caption")
            let imageLocation = getDocumentsDirectory().appendingPathComponent(photo.fileName)
            
            do {
                try imageData.write(to: imageLocation)
                photos.append(photo)
  
            } catch {
                print(error)
            }
        }
    }
    
    
    func saveToUserDefaults() {
        let encoder = JSONEncoder()
       
        do {
            let dataPhotos = try encoder.encode(photos)
            UserDefaults.standard.setValue(dataPhotos, forKey: userDefaultsKey)

        } catch {
            print(error)
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
}

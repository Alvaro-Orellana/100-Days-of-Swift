//
//  ViewController.swift
//  Project 10
//
//  Created by Alvaro Orellana on 01-06-21.
//

import UIKit

class ViewController: UICollectionViewController {
    
    var people = [Person]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addImagePressed))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Show people", style: .done, target: self, action: #selector(printAllPeople))
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PersonCell", for: indexPath) as? PersonCell else {
            fatalError("Could not deque cell for collection view")
        }
        
        let person = people[indexPath.item]
        let imagePath = getDocumentsDirectory().appendingPathComponent(person.imageId)
        
        cell.imageView.image = UIImage(contentsOfFile: imagePath.path)
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        cell.label.text = person.name
        
        return cell
    }
    
    
    @objc private func printAllPeople() {
        print(people.description)
    }
    
    
    @objc private func addImagePressed() {
        // Create and present ImagePickerController
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedPerson = people[indexPath.item]
        
        let alert = UIAlertController(title: "Update name", message: nil, preferredStyle: .alert)
        alert.addTextField()
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default) { _ in
            if let newName = alert.textFields?[0].text {
                selectedPerson.name = newName
                collectionView.reloadData()
            }
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
        
        present(alert, animated: true)
    }
    
}



// MARK: - UIImagePickerControllerDelegate
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return  }
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            saveImageToDisk(image: jpegData)
        }
        
        dismiss(animated: true)
    }
}



// MARK: - File System interactiong functions
extension ViewController {
   
    private func saveImageToDisk(image: Data) {
        let imageId = UUID().uuidString
        let imagePath  = getDocumentsDirectory().appendingPathComponent(imageId) // Location where photo will be saved
        
        do {
            try image.write(to: imagePath)
            people.append(Person(name: "Unknown", imagePath: imageId))
            self.collectionView.reloadData()
        
        } catch  {
            print("Couldn't save image to data. Error: \(error)")
        }
        
    }
  
    private func getDocumentsDirectory() -> URL {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return documentsPath[0]
    }
}


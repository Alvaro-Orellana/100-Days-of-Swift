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
        
        loadPeople()
    }
    
    private func loadPeople() {
        let defaults = UserDefaults.standard

        if let savedPeople = defaults.object(forKey: "people") as? Data {
            let jsonDecoder = JSONDecoder()

            do {
                people = try jsonDecoder.decode([Person].self, from: savedPeople)
            } catch {
                print("Failed to load people")
            }
        }
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PersonCell", for: indexPath) as? PersonCell
        else {
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
        print(people)
    }
    
    
    @objc private func addImagePressed() {
        // Create and present ImagePickerController
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        }
        picker.delegate = self
        present(picker, animated: true)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Creates and presents Alert Controller
        let alert = UIAlertController(title: "Choose Action", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Change name", style: .default) { _ in
            self.updateNameAlert(at: indexPath.item)
        })
        
        alert.addAction(UIAlertAction(title: "Delete item", style: .destructive) { _ in
            self.deletePerson(at: indexPath.item)
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
        
        present(alert, animated: true)
    }
    
    
    private func updateNameAlert(at index: Int) {
        let selectedPerson = people[index]
        
        let alert = UIAlertController(title: "Update name", message: nil, preferredStyle: .alert)
        alert.addTextField()
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default) { _ in
            if let newName = alert.textFields?[0].text {
                selectedPerson.name = newName
                self.save()
                self.collectionView.reloadData()
            }
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
        
        present(alert, animated: true)
    }
    
    
    private func deletePerson(at index: Int) {
        // TODO: Remove from disk
        let imagePath  = getDocumentsDirectory().appendingPathComponent(people[index].imageId) // Location where photo is be saved
        do {
            try FileManager.default.removeItem(at: imagePath)
            people.remove(at: index)
            collectionView.reloadData()

        } catch {
            print("Couldn't delete image from disk. Error: \(error)")
        }
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



// MARK: - File System interacting functions
extension ViewController {
   
    private func saveImageToDisk(image: Data) {
        let imageId = UUID().uuidString
        let imagePath  = getDocumentsDirectory().appendingPathComponent(imageId) // Location where photo will be saved
        
        do {
            try image.write(to: imagePath)
            people.append(Person(name: "Unknown", imagePath: imageId))
            self.save()
            self.collectionView.reloadData()
        
        } catch  {
            print("Couldn't save image to data. Error: \(error)")
        }
    }
    
  
    private func getDocumentsDirectory() -> URL {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return documentsPath[0]
    }
    
    
    func save() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(people) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "people")
        } else {
            print("Failed to save people.")
        }
    }
}


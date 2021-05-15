//
//  ViewController.swift
//  Project 6
//
//  Created by Alvaro Orellana on 14-05-21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var randomColorsButton: UIButton!
    var labelsArray: [UILabel]!

    var verticalSpaceBetweenLabels: CGFloat = 0
    var horizontalSpaceToSidesOfLabels: CGFloat = 0
    var isChangingColors = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        randomColorsButton.layer.cornerRadius = 12
        
        labelsArray = createLabels()
        addAndPositionLabels(labelsArray)
    }
    
    
    private func createLabels() -> [UILabel] {
        let label1 = createLabel(withTitle: "THESE", color: .red)
        let label2 = createLabel(withTitle: "ARE", color: .cyan)
        let label3 = createLabel(withTitle: "SOME", color: .yellow)
        let label4 = createLabel(withTitle: "AWESOME", color: .green)
        let label5 = createLabel(withTitle: "LABELS", color: .orange)
        let label6 = createLabel(withTitle: "MORE", color: .brown)
        let label7 = createLabel(withTitle: "COLORSSS", color: .darkGray)

        return [label1, label2, label3, label4, label5, label6, label7]
    }

    
    private func createLabel(withTitle title: String, color: UIColor) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = color
        label.text = title
        label.textColor = .white
        label.textAlignment = .center
        label.sizeToFit()
        
        return label
    }

    
    private func addAndPositionLabels(_ labels: [UILabel]) {
        
        let safeAreaAnchors = view.safeAreaLayoutGuide

        var previousLabel: UILabel?
        
        for label in labels {
            view.addSubview(label)
            
            label.heightAnchor.constraint(equalTo: safeAreaAnchors.heightAnchor, multiplier: CGFloat(1 / Double(labelsArray.count + 2) ), constant: -(verticalSpaceBetweenLabels)).isActive = true

            label.leadingAnchor.constraint(equalTo: safeAreaAnchors.leadingAnchor, constant: horizontalSpaceToSidesOfLabels).isActive = true
            label.trailingAnchor.constraint(equalTo: safeAreaAnchors.trailingAnchor, constant: -horizontalSpaceToSidesOfLabels).isActive = true
            
            
            if let previousLabel = previousLabel {
                // Top of label is at the bottom anchor of the previous label which is on the top
                label.topAnchor.constraint(equalTo: previousLabel.bottomAnchor, constant: verticalSpaceBetweenLabels).isActive = true
            } else {
                // This is the top label
                label.topAnchor.constraint(equalTo: safeAreaAnchors.topAnchor).isActive = true
            }
            
            previousLabel = label
        }
    }
    
    private func removeAllLabels() {
        for label in labelsArray {
            label.removeFromSuperview()
        }
    }
    
    @IBAction func verticalSliderChanged(_ sender: UISlider) {
        verticalSpaceBetweenLabels = CGFloat(sender.value)
        
        removeAllLabels()
        addAndPositionLabels(labelsArray)
    }
    
    
    @IBAction func horizontalSliderChanged(_ sender: UISlider) {
        horizontalSpaceToSidesOfLabels = CGFloat(sender.value) * 2
        
        removeAllLabels()
        addAndPositionLabels(labelsArray)
    }
    
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        changeLabelsColors()
    }
    
    
    var timer: Timer?
    @IBAction func randomColorsTouched(_ sender: UIButton) {
        isChangingColors.toggle()
        
        if isChangingColors {
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                self.changeLabelsColors()
            }
            sender.setTitle("Stop", for: .normal)
            
        } else {
            timer?.invalidate()
            sender.setTitle("Random colors!", for: .normal)
        }
        
        
        
        
        
    }
    
    private func changeLabelsColors() {
        for label in labelsArray {
            label.backgroundColor = .random()
        }
    }

}



extension UIColor {
    static func random() -> UIColor {
        return UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1)
    }
}

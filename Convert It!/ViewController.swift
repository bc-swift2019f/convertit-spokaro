//
//  ViewController.swift
//  Convert It!
//
//  Created by Andrew Boucher on 9/30/19.
//  Copyright © 2019 Andres de la Cruz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var userTextField: UITextField!
    
    @IBOutlet weak var fromUnitsLabel: UILabel!
    
    @IBOutlet weak var resultsLabel: UILabel!
    
    @IBOutlet weak var formulaPicker: UIPickerView!
    
    
    var formulaArray = ["miles to kilometers", "kilometers to miles", "feet to meters", "yards to meters", "meters to feet", "meters to yards" ]
    
    var fromUnits = ""
    var toUnits = ""
    var convertionString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        formulaPicker.delegate = self
        formulaPicker.dataSource = self
    }

    func calculateConvertion() {
        var outputValue = 0.0
        if let inputValue = Double(userTextField.text!) {
            switch convertionString {
            case "miles to kilometers":
                outputValue = inputValue / 0.62137
            case "kilometers to miles":
                outputValue = inputValue * 0.62137
            case "feet to meters":
                outputValue = inputValue / 3.2808
            case "yards to meters":
                outputValue = inputValue / 1.0936
            case "meters to feet":
                outputValue = inputValue * 3.2808
            case "meters to yards":
                outputValue = inputValue / 1.0936
            default:
                print("Show alert - For some reason we did not have a convertion string")
            }
            resultsLabel.text = "\(inputValue) \(fromUnits) = \(outputValue) \(toUnits)"
        }else {
            print("show alert here to say the value entered was not a number")
        }
        
       
    }
    
    @IBAction func convertButtonPressed(_ sender: UIButton) {
    }
    
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return formulaArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return formulaArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        convertionString = formulaArray[row]
        let unitsArray = formulaArray[row].components(separatedBy: " to ")
        fromUnits = unitsArray[0]
        toUnits = unitsArray[1]
        fromUnitsLabel.text = fromUnits
        calculateConvertion()
    }
}

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
    
    @IBOutlet weak var decimalSegment: UISegmentedControl!
    
    @IBOutlet weak var signSegment: UISegmentedControl!
    
    var formulaArray = ["miles to kilometers", "kilometers to miles", "feet to meters", "yards to meters", "meters to feet", "meters to yards", "inches to cm", "cm to inches", "fahrenheit to celsius", "celsius to fahrenheit", "quarts to liters", "liters to quarts"]
    
    var fromUnits = ""
    var toUnits = ""
    var convertionString = ""
    
    //MARK:- Class Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        formulaPicker.delegate = self
        formulaPicker.dataSource = self
        convertionString = formulaArray[formulaPicker.selectedRow(inComponent: 0)]
        signSegment.isHidden = true
    }

    func calculateConvertion() {
 
        guard let inputValue = Double(userTextField.text!) else {
            if userTextField.text != "" {
                showAlert(title: "Cannot Convert Value", message: "\"\(String(describing: userTextField.text))\" is not a valid number." )
            }
            return
            }
        
        var outputValue = 0.0
        
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
                outputValue = inputValue * 1.0936
            case "inches to cm":
                outputValue = inputValue / 0.3937
            case "cm to inches":
                outputValue = inputValue * 0.3937
            case "fahrenheit to celsius":
                outputValue = (inputValue - 32) * 5/9
            case "celsius to fahrenheit":
                outputValue = (inputValue * ( 9/5)) + 32
            case "quarts to liters":
                outputValue = inputValue / 1.05669
            case "liters to quarts":
                outputValue = inputValue * 1.05669

            default:
                showAlert(title: "Unexpect error", message: "Contant developer for help." )
            }
        let formatString = (decimalSegment.selectedSegmentIndex < decimalSegment.numberOfSegments-1 ? "%.\(decimalSegment.selectedSegmentIndex+1)f" : "%f")
        
        let outputString = String(format: formatString, outputValue)
        resultsLabel.text = "\(inputValue) \(fromUnits) = \(outputString) \(toUnits)"
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
        
    }
    
    // MARK:- IBActions
    @IBAction func decimalSelected(_ sender: UISegmentedControl) {
        calculateConvertion()
    }
    
    @IBAction func UserTextFieldChanged(_ sender: UITextField) {
        resultsLabel.text = ""
        if userTextField.text?.first == "-" {
            signSegment.selectedSegmentIndex = 1
        }else {
            signSegment.selectedSegmentIndex = 0
        }
        
    }
    
    @IBAction func signSegmentSelect(_ sender: UISegmentedControl) {
        if signSegment.selectedSegmentIndex == 0 {
            userTextField.text = userTextField.text?.replacingOccurrences(of: "-", with: "")
        }else{
            userTextField.text = "-" + userTextField.text!
        }
        if userTextField.text != "-" {
        calculateConvertion()
        }
    }
    
    @IBAction func convertButtonPressed(_ sender: UIButton) {
        calculateConvertion()
    }
    
}
//MARK:-  PickerView Extension
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
        
        if convertionString.lowercased().contains("celsius".lowercased()){
            signSegment.isHidden = false
        } else {
            signSegment.isHidden = true
            userTextField.text = userTextField.text?.replacingOccurrences(of: "-", with: "")
            signSegment.selectedSegmentIndex = 0
        }
        let unitsArray = formulaArray[row].components(separatedBy: " to ")
        fromUnits = unitsArray[0]
        toUnits = unitsArray[1]
        fromUnitsLabel.text = fromUnits
        calculateConvertion()
    }
}

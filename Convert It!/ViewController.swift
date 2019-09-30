//
//  ViewController.swift
//  Convert It!
//
//  Created by Andrew Boucher on 9/30/19.
//  Copyright © 2019 Andres de la Cruz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    struct Formula {
        var convertionString: String
        var formula: (Double) -> Double
    }

    @IBOutlet weak var userTextField: UITextField!
    
    @IBOutlet weak var fromUnitsLabel: UILabel!
    
    @IBOutlet weak var resultsLabel: UILabel!
    
    @IBOutlet weak var formulaPicker: UIPickerView!
    
    @IBOutlet weak var decimalSegment: UISegmentedControl!
    
    @IBOutlet weak var signSegment: UISegmentedControl!
    
    let formulasArray = [Formula(convertionString: "miles to kilometers", formula: {$0 / 0.62137}),
                        Formula(convertionString: "kilometers to miles", formula: {$0 * 0.62137}),
                        Formula(convertionString: "feet to meters", formula: {$0 / 3.2808}),
                        Formula(convertionString: "yards to meters", formula: {$0 / 1.0936}),
                        Formula(convertionString: "meters to feet", formula: {$0 * 3.2808}),
                        Formula(convertionString: "meters to yards", formula: {$0 * 1.0936}),
                        Formula(convertionString: "inches to cm", formula: {$0 / 0.3937}),
                        Formula(convertionString: "cm to inches", formula: {$0 * 0.3937}),
                        Formula(convertionString: "fahrenheit to celsiu", formula: {($0 - 32) * 5/9}),
                        Formula(convertionString: "celsius to fahrenheit", formula: {($0 * ( 9/5)) + 32}),
                        Formula(convertionString: "quarts to liters", formula: {$0 / 1.05669}),
                        Formula(convertionString: "liters to quarts", formula: {$0 * 1.05669})]
    var fromUnits = ""
    var toUnits = ""
    var convertionString = ""
    
    //MARK:- Class Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        formulaPicker.delegate = self
        formulaPicker.dataSource = self
        convertionString = formulasArray[formulaPicker.selectedRow(inComponent: 0)].convertionString
        let unitsArray = convertionString.components(separatedBy: " to ")
        fromUnits = unitsArray[0]
        fromUnitsLabel.text = fromUnits
        toUnits = unitsArray[1]
        userTextField.becomeFirstResponder()
        signSegment.isHidden = true
    }

    func calculateConvertion() {
 
        guard let inputValue = Double(userTextField.text!) else {
            if userTextField.text != "" {
                showAlert(title: "Cannot Convert Value", message: "\"\(String(describing: userTextField.text))\" is not a valid number." )
            }
            return
            }
        
        let outputValue = formulasArray[formulaPicker.selectedRow(inComponent: 0)].formula(inputValue)
        
        
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
        return formulasArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return formulasArray[row].convertionString
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        convertionString = formulasArray[row].convertionString
        
        if convertionString.lowercased().contains("celsius".lowercased()){
            signSegment.isHidden = false
        } else {
            signSegment.isHidden = true
            userTextField.text = userTextField.text?.replacingOccurrences(of: "-", with: "")
            signSegment.selectedSegmentIndex = 0
        }
        let unitsArray = formulasArray[row].convertionString.components(separatedBy: " to ")
        fromUnits = unitsArray[0]
        toUnits = unitsArray[1]
        fromUnitsLabel.text = fromUnits
        calculateConvertion()
    }
}

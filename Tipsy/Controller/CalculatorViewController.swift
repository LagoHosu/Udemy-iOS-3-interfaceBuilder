//
//  ViewController.swift
//  Tipsy
//
//  Created by Angela Yu on 09/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
    
    
    @IBOutlet weak var billTextField: UITextField!
    @IBOutlet weak var zeroPctButton: UIButton!
    @IBOutlet weak var tenPctButton: UIButton!
    @IBOutlet weak var twentyPctButton: UIButton!
    @IBOutlet weak var splitNumberLabel: UILabel!
    
    /*
     @IBAction func tipChanged(_ sender: UIButton) {
     var zeroNum = 0.0
     var tenNum = 0.1
     var twentyNum = 0.2
     
     zeroPctButton.isSelected = false
     tenPctButton.isSelected = false
     twentyPctButton.isSelected = false
     
     
     if sender.isSelected == true {
     print
     }
     //        tenPctButton.isSelected = true
     //        twentyPctButton.isSelected = true
     }
     */
    
    var totAmount = 0.0
    var tip = 0.10
    var totalBill = 0.0
    var perPerson = 0.0
    @IBAction func tipChanged(_ sender: UIButton) {
        zeroPctButton.isSelected=false
        tenPctButton.isSelected=false
        twentyPctButton.isSelected=false
        
        sender.isSelected = true //only this line is enough to highlight
        
        let selectedValue = sender.currentTitle!
        let removeMinuSign = String(selectedValue.dropLast())
        let buttonValue = Double(removeMinuSign)
        tip = buttonValue!/100
        
        
    }
    
    var numOfPeople = 0.0
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        let splitText = String(Int(sender.value))
        splitNumberLabel.text = splitText
        numOfPeople = Double(splitNumberLabel.text!)!
    }
    
    @IBAction func calculatePressed(_ sender: UIButton) {
        
        billTextField.endEditing(true)
        let billText = billTextField.text!
        totalBill = Double(billText) ?? 99.99
        
        perPerson = (totalBill + totalBill*tip) / numOfPeople
        print(String(format: "%.2f", perPerson))
        
        self.performSegue(withIdentifier: "goToResult", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToResult" {
            let destinationVC = segue.destination as! ResultsViewController  //as for downcasting, as! for forced downcast
            
            destinationVC.fin = perPerson
            destinationVC.tip = Int(tip*100)
            destinationVC.split = Int(numOfPeople)
        }
    }
            
}


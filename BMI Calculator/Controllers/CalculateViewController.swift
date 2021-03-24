//
//  ViewController.swift
//  BMI Calculator
//
//  Created by Angela Yu on 21/08/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit

class CalculateViewController: UIViewController {
    
    var calculatorBrain = CalculatorBrain()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var heightSlider: UISlider!
    @IBOutlet weak var weightSlider: UISlider!
    
    
    
    @IBAction func heightSliderChanged(_ sender: UISlider) {
        //print(sender.value)
        //heightLabel.text = String(format: "%.2f", sender.value) + "m"
        let height = String(format: "%.2f", sender.value)
        heightLabel.text = "\(height)m"
    }
    @IBAction func weightSliderChanged(_ sender: UISlider) {
        //weightLabel.text = String(format: "%.0f", sender.value) + "kg"
        let weight = String(format: "%.0f", sender.value)
        weightLabel.text = "\(weight)kg"
    }
    @IBAction func calculatePressed(_ sender: UIButton) {
//        print(heightLabel.text!)
//        print(weightLabel.text!)
        let height = heightSlider.value
        let weight = weightSlider.value
        //let BMI = weight/height/height
        let BMI = weight/pow(height, 2) //pow(a, n) a값을 n번 제곱한 값
        print("\(height) is your height")
        print("\(weight) is your weight")
        print(BMI)
        
        calculatorBrain.calculateBMI(height: height, weight: weight)
        self.performSegue(withIdentifier: "goToResult", sender: self)
        
        
        

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToResult" {
            let destinationVC = segue.destination as! ResultViewController  //as for downcasting, as! for forced downcast
            destinationVC.bmiValue = calculatorBrain.getBMIValue()
            destinationVC.advice = calculatorBrain.getAdvice()
            destinationVC.color = calculatorBrain.getColor()

        }
    }

}


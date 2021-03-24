//
//  CalculatorBrain.swift
//  BMI Calculator
//
//  Created by Lago on 2020/12/15.
//  Copyright © 2020 Angela Yu. All rights reserved.
//

import UIKit

struct CalculatorBrain {
    var bmi: BMI?
    
    func getBMIValue() -> String {
        let bmiToOne = String(format: "%.1f", bmi?.value ?? 0.0)
        return bmiToOne
    }
    
    
    func getAdvice() -> String {
        return bmi?.advice ?? "No advice"
    }
    
    
    func getColor() -> UIColor {
        return bmi?.color ?? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    
    mutating func calculateBMI(height: Float, weight: Float) {
        let bmiValue = weight/pow(height, 2)
        //let adviceText = advice
        
        if bmiValue<18.5 {
            bmi = BMI(value: bmiValue, advice: "Eat more pies", color: #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1))
        } else if bmiValue<24.9{    //else statement makes another case from former case
            bmi = BMI(value: bmiValue, advice: "Fir as a fiddle!", color: #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1))
        } else {
            bmi = BMI(value: bmiValue, advice: "Eat less pies", color: #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1))
        }
    }
    
    //    var getBMIValue = weight/pow(height, 2)
    
}

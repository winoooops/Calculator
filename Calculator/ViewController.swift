//
//  ViewController.swift
//  Calculator
//
//  Created by Will Wong (Winoooops) on 2020/4/9.
//  Copyright © 2020 winoooops. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        displayLabel.text = "0"
        // Do any additional setup after loading the view.
    }

    var currNumber: Double = 0 // this can be change by user input or math operation
    var prevNumber: Double = 0 // only used for math operation
    var isCalculated: Bool = false // condition statement for rendering different result
    var clickedOperationKey: UIButton? // this is used so the programe will know which button to toggle the background color
    var mathSymbol: String = "" // globally store the the math operation selected
    
    
    @IBOutlet var numberButtons: [UIButton]!
    
    @IBOutlet weak var displayLabel: UILabel!
    
    
    @IBAction func doOperation(_ sender: UIButton) {
        /***************************
        * 0. highlight the operation buttons to inhance interactivity
        * 1. know what operation is requested
        * 2. reset the displayLabel after operation button is clicked
        * 2. use the previous stored item and the current display item to calculated
        * 3. show the result inside the displayLabel
        *
        */
       
        
        let opTitle = sender.title(for: .normal)! // one of ["+", "-", "x", "/", "C", "="]
       
        if opTitle == "C" {
            resetOperation()
        } else if opTitle == "+/-" {
            //toggle the minus state
            currNumber = -currNumber
            displayLabel.text = String(format: "%g", currNumber) // omit the unessary 0
        } else if opTitle == "%" {
            currNumber = currNumber / 100
            displayLabel.text = String(format: "%g", currNumber)
        } else if opTitle == "=" {
            // if there's no math symbol clicked before
            if clickedOperationKey == nil {
                displayLabel.text = String(format: "%g", currNumber)
            } else {
                // if there's math symbol clicked before
        
                let number = Double(displayLabel.text!)! // take down the new number
                // assign currNumber with the new calculated result
                currNumber = doMathOperation(prev: prevNumber, curr: number, symbol: mathSymbol)
                prevNumber = number // update the prevNumber so it always is the last inputed number, this is important for accumulative operations
                displayLabel.text = String ( format: "%g", currNumber )
                clickedOperationKey!.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1) // trackback to the operational button clicked and deactivate it
                isCalculated = true // now the math operation is completed, put tag into it
//                print("and \(currNumber)")
            }
            
        } else {
            // if ["+", "-", "x", "/"] is clicked
            
            sender.backgroundColor = #colorLiteral(red: 0.5791940689, green: 0.1280144453, blue: 0.5726861358, alpha: 1) // for operations, highlight the button clicked
            clickedOperationKey = sender // need to know how to pinpoint to it in "=" operation
            mathSymbol = opTitle // need to store the opeartional mark for "=" operation as well
            prevNumber = Double(displayLabel.text!) ?? 0 // if nothing is given previously, use 0
            displayLabel.text = "" //clear the number and prompts user for another input
//            print("do \(opTitle) with \(prevNumber)")
        }
        
    
    }
    
    //take two numbers and operational symbol, and return the result
    func doMathOperation(prev a: Double, curr b: Double, symbol mark: String) -> Double{
        switch mark {
        case "+" :
            return a+b
        case "-":
            return a-b
        case "x":
            return a*b
        case "/":
            return a/b
        default:
            return b // guess this never gets run
        }
    }
    
    func resetOperation() {
        // for the "C" opeartion
        // reset everything to default -> better way is to release any buffer/memory ?
        displayLabel.text = "0"
        prevNumber = 0
        currNumber = 0
        isCalculated = false
        clickedOperationKey = nil
    }
    
//    func prettyNumber(_ number: Double) -> String{
//        let formatter = NumberFormatter()
//        formatter.minimumIntegerDigits = 0
//        return formatter.string( from: NSNumber(value: number) )!
//    }
    
    
    @IBAction func touchNumberKey(_ sender: UIButton) {
        // when use tap on number keys ["0","1","2","3","4","5","6","7","8","9","."]
        let title = sender.title(for: .normal)!
//        print(title)
//        var text = ""
//        print("\(title) key is clicked...")
        // if the current displayLabel is the result of previous math operation
        if isCalculated == true {
            resetOperation()
        }
            /**********************************************
            * Issue fixed: fatal exception where user inputs "." first
            * by settting the displayLabel.text's initial value in viewDidLoad()
            **********************************************/
        
        // if title is zero, ignore them, unless there's a decimal point
        if displayLabel.text!.contains(".") == false && title == "0" {
            displayLabel.text = displayLabel.text! // ignore
        }
        else {
            // omit the leading zeros
           displayLabel.text = displayLabel.text! + title
        }
        //take down what's on the displayLabel
//        displayLabel.text = displayLabel.text! + title
        currNumber = Double(displayLabel.text!)!
    }
}


//
//  ViewController.swift
//  Calculator
//
//  Created by shanshan·pan on 2019/2/23.
//  Copyright © 2019 shanshan·pan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var userIsInTheMiddleOfTypingANumber = false
    var operandStack = Array<Double>()
    var displayValue: Double {
        get {
            let number = NumberFormatter().number(from: display.text!)
            return number !== nil ? number!.doubleValue : 0
        }
        set {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }
    var currentOperattion:String? = nil
    //计算器显示器
    @IBOutlet weak var display: UILabel!
    //绑定符号
    @IBAction func appendDigit(_ sender: UIButton) {
        let symbol = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            if(symbol == "−"){
                return
            }
            display.text = display.text! + symbol
        } else {
            if(symbol == "−"){
                if(operandStack.count == 0){
                    display.text = symbol
                }
                return
            }
            display.text = symbol
        }
        if symbol != "−" {
           userIsInTheMiddleOfTypingANumber = true
        }
    }
    //计算结果
    @IBAction func computation() {
        enter()
        if currentOperattion != nil {
            switchOperattionAndComputationTheResult(currentOperattion!)
            currentOperattion = nil
        }
    }
    func enter() {
        userIsInTheMiddleOfTypingANumber = false
        operandStack.append(displayValue)
        print("operandStack = \(operandStack)")
    }
    //加减乘除的选择
    @IBAction func operate(_ sender: UIButton) {
        let operattion = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            computation()
        } else if (operattion == "−" && operandStack.count == 0){
            userIsInTheMiddleOfTypingANumber = true
            return
        }
        currentOperattion = operattion
        switchOperattionAndComputationTheResult(operattion)
    }
    func switchOperattionAndComputationTheResult(_ operattion:String){
            switch operattion {
            case "×":performOperation {
                $0.multiplying(by: $1)
            }
                break
            case "÷":performOperation {
                $1.dividing(by: $0)
            }
                break
            case "+":performOperation {
                $1.adding($0)
            }
                break
            case "−":performOperation {
                $1.subtracting($0)
            }
                break
            case "√": performOperation {sqrt($0)}
                break
            default: break
            }
    }
    func performOperation(opration: (NSDecimalNumber, NSDecimalNumber) -> NSDecimalNumber ){
        if(operandStack.count >= 2) {
            let op1 = NSDecimalNumber.init(value: operandStack.removeLast())
            let op2 = NSDecimalNumber.init(value: operandStack.removeLast())
            displayValue = Double(truncating: opration(op1, op2))
            enter()
        }
    }
    func performOperation(opration: (Double) -> Double ){
        if(operandStack.count >= 1) {
            displayValue = opration(operandStack.removeLast())
            enter()
        }
    }
    @IBAction func clear() {
        operandStack = []
        display.text = "0"
        userIsInTheMiddleOfTypingANumber = false
    }
    
    @IBAction func delete() {
        var displayString = display.text!
        if displayString.count >= 1 {
            displayString.remove(at: displayString.index(before: displayString.endIndex))
            display.text = displayString
            if displayString == "" {
                display.text = "0"
                userIsInTheMiddleOfTypingANumber = false
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


}


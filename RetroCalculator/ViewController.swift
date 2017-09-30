//
//  ViewController.swift
//  RetroCalculator
//
//  Created by Руслан Акберов on 17.09.17.
//  Copyright © 2017 Руслан Акберов. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var outputLabel: UILabel!
    @IBOutlet weak var zeroButton: UIButton!
    
    var btnSound: AVAudioPlayer!
    
    enum Operations: String {
        case Multiply = "*"
        case Divide = "/"
        case Substract = "-"
        case Add = "+"
        case Empty = "Empty"
    }
    
    var currentOperation = Operations.Empty
    var runningNumber = ""
    var leftValueString = ""
    var rightValueString = ""
    var result = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = Bundle.main.path(forResource: "btn", ofType: "wav")
        let soundURL = URL(fileURLWithPath: path!)
        
        do {
            try btnSound = AVAudioPlayer(contentsOf: soundURL)
            btnSound.prepareToPlay()
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        outputLabel.text = "0"
    }
    
    func playSound() {
        if btnSound.isPlaying {
            btnSound.stop()
        }
        btnSound.play()
    }
    
    @IBAction func numberPressed(sender: UIButton) {
        playSound()
        if sender.tag == 0 && runningNumber == "" {
            runningNumber = ""
            outputLabel.text = "0"
        } else {
            runningNumber += "\(sender.tag)"
            outputLabel.text = runningNumber
        }
    }
    
    @IBAction func onDividePressed(sender: AnyObject) {
        processOperation(operation: .Divide)
    }
    
    @IBAction func onMultiplyPressed(sender: AnyObject) {
        processOperation(operation: .Multiply)
    }
    
    @IBAction func onSubstractPressed(sender: AnyObject) {
        processOperation(operation: .Substract)
    }
    
    @IBAction func onAddPressed(sender: AnyObject) {
        processOperation(operation: .Add)
    }
    
    @IBAction func onEqualPressed(sender: AnyObject) {
        processOperation(operation: currentOperation)
    }
    
    @IBAction func clearButtonPressed(_ sender: Any) {
        playSound()
        currentOperation = Operations.Empty
        runningNumber = ""
        leftValueString = ""
        rightValueString = ""
        result = ""
        outputLabel.text = "0"
    }
    
    func processOperation(operation: Operations) {
        playSound()
        if currentOperation != Operations.Empty {
            // A user selected an operator, but then selected  another operator without first entering number
            
            if runningNumber != "" {
                rightValueString = runningNumber
                runningNumber = ""
                if currentOperation == Operations.Multiply {
                    result = "\(Double(leftValueString)! * Double(rightValueString)!)"
                } else if currentOperation == Operations.Divide {
                    result = "\(Double(leftValueString)! / Double(rightValueString)!)"
                } else if currentOperation == Operations.Substract {
                    result = "\(Double(leftValueString)! - Double(rightValueString)!)"
                } else if currentOperation == Operations.Add {
                    result = "\(Double(leftValueString)! + Double(rightValueString)!)"
                }
                leftValueString = result
                outputLabel.text = result
            }
            currentOperation = operation
        } else {
            // This is the first time an operator has been pressed
            leftValueString = runningNumber
            runningNumber = ""
            currentOperation = operation
        }
    }

}


//
//  ViewController.swift
//  Calculator
//
//  Created by Consultant on 6/3/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var calcProblem: UILabel!
    
    @IBOutlet weak var calcAnswer: UILabel!
    
    var problem: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clearWork()
        // Do any additional setup after loading the view.
    }
    //call to clear calculator
    func clearWork(){
        problem = ""
        calcProblem.text = ""
        calcAnswer.text = ""
        calcAnswer.text = "0"

    }
    
    
    
    
    @IBAction func Clear(_ sender: Any) {
        clearWork()
    }
    
    func addProblem(value: String)
    {
        problem = problem + value
        calcProblem.text = problem
    }
    
    
    
    
    
    
    
    
    
    @IBAction func posneg(_ sender: Any) {
        
    }
    @IBAction func percent(_ sender: Any) {
        addProblem(value: "%")
    }
    
    @IBAction func calcDiv(_ sender: Any) {
        addProblem(value: "/")

    }
    
    @IBAction func calcSeven(_ sender: Any) {
        addProblem(value: "7")

    }
    
    @IBAction func calcEight(_ sender: Any) {
        addProblem(value: "8")

    }
    
    @IBAction func calcNine(_ sender: Any) {
        addProblem(value: "9")

    }
    
    @IBAction func calcMulti(_ sender: Any) {
        addProblem(value: "*")

    }
    
    @IBAction func calcFour(_ sender: Any) {
        addProblem(value: "4")

    }
    
    @IBAction func calcFive(_ sender: Any) {
        addProblem(value: "5")

    }
    
    @IBAction func calcSix(_ sender: Any) {
        addProblem(value: "6")

    }
    
    @IBAction func calcSub(_ sender: Any) {
        addProblem(value: "-")

    }
    
    @IBAction func calcOne(_ sender: Any) {
        addProblem(value: "1")

    }
    
    @IBAction func calcTwo(_ sender: Any) {
        addProblem(value: "2")

    }
    
    @IBAction func calcThree(_ sender: Any) {
        addProblem(value: "3")

    }
    
    
    @IBAction func calcAdd(_ sender: Any) {
        addProblem(value: "+")

    }
    
    @IBAction func calcZero(_ sender: Any) {
        addProblem(value: "0")

    }
    
    @IBAction func calcDecimal(_ sender: Any) {
        addProblem(value: ".")

    }
    //calculations
    @IBAction func calcEqual(_ sender: Any) {
        
        
                    //percent rule
                    let checkedWorkingsForPercent = problem.replacingOccurrences(of: "%", with: "*0.01")
                    let mathExpression = NSExpression(format: checkedWorkingsForPercent)
                    let answer = mathExpression.expressionValue(with: nil, context: nil) as! Double
                    let answerString = format(answer: answer)
                    calcAnswer.text = answerString
                
                
        

    }
    //return the answer as a string
    func format(answer: Double) -> String
     {
         if(answer.truncatingRemainder(dividingBy: 1) == 0){
             return String(format: "%.f", answer)
         }
         else
         {
             return String(format: "%2.f", answer)
         }
     }
    
    
}


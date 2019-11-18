//
//  IlyinTestViewController.swift
//  Diplom
//
//  Created by BigDude6 on 28/05/2019.
//  Copyright © 2019 FixXcodeBug. All rights reserved.
//

import UIKit

class IlyinTestViewController: UIViewController, Test {
    func launchNextTest() {
        if profession!.testNames.isEmpty {
            let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "ResultsTable") as! ResultTableViewController
            VC1.results = results
            let navController = UINavigationController(rootViewController: VC1) // Creating a navigation controller with VC1 at the root of the navigation stack.
            self.present(navController, animated:true, completion: nil)
        }
        else {
            let contoller = storyboard?.instantiateViewController(withIdentifier: "TestInfo") as! TestInfoViewController
            contoller.profession = profession
            contoller.results = results
            present(contoller, animated: true, completion: nil)
        }
    }
    
    var results:[ResultItem]?
    var profession:Profession?
    var isTestBegan = false
    var tapCounts = [Int]()
    var currentTapCounts = 0
    var testNumber = 0
    var timer = Timer()
    
    @IBAction func startButtonDidPressed(_ sender: UIButton) {
        sender.isHidden = true
        isTestBegan = true
        let TEST_TIME = 5.0 // ЗАМЕНИ на 5.0 И УДАЛИ
        timer = Timer.scheduledTimer(timeInterval: TEST_TIME, target: self, selector: #selector(timerUpdate), userInfo: NSDate(), repeats: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if results == nil {
            results = []
        }
        let mytapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        mytapGestureRecognizer.numberOfTapsRequired = 1
        self.view?.addGestureRecognizer(mytapGestureRecognizer)
    }
    
    @objc func tapAction(recognizer: UITapGestureRecognizer) {
        if isTestBegan {
            currentTapCounts += 1
            drawCircle(for: recognizer)
        }
    }
    
    
    @objc func timerUpdate(){
        testNumber += 1
        tapCounts.append(currentTapCounts)
        print("Test \(testNumber) ended")
        currentTapCounts = 0
        view.layer.sublayers?.removeAll(where: {$0 is CAShapeLayer})
        UIView.animate(withDuration: 0.3){
            self.view.backgroundColor = .clear
            self.view.layer.backgroundColor = UIColor(red:0.45, green:0.99, blue:0.84, alpha:1.0).cgColor
            self.view.layer.backgroundColor = UIColor.white.cgColor
        }
        if testNumber == 6 {
            isTestBegan = false
            timer.invalidate()
            if results == nil {
                results = [ResultItem]()
            }
            let result = ResultItem(type: TestTypes.Ilyin, time: 0, description: getTestReslut(results: tapCounts), mistakes: 0)
            results?.append(result)
            launchNextTest()
        }
    }
    
    
    
    func drawCircle(for tap: UITapGestureRecognizer){
        let tapLocation = tap.location(in: tap.view)
        let circlePath = UIBezierPath(arcCenter: tapLocation, radius: CGFloat(2), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.lineWidth = 4
        
        view.layer.addSublayer(shapeLayer)
    }
    
    func getTestReslut(results: [Int]) -> String {
        
        var isStrong = false
        let meanResult = results.reduce(0, +) / results.count
        let maxResult = results.max()
        var isWeak = true
        var isMiddle = true
        var lastResult = results[0] + 1
        //WEAK
        for result in results {
            if lastResult < result{
                isWeak = false
                break
            }
            lastResult = result
        }
        if isWeak {
            return "Weak"
        }
        //Middle
        let delta = 4
        for i in results {
            if abs(i - meanResult) > delta {
                isMiddle = false
            }
        }
        
        if isMiddle {
            return "Middle"
        }
        
        //check STRONG
        var resString = ""
        for i in 0...4 {
            resString += results[i+1] >= results[i] ? "+" : "-"
        }
        if (resString != "+++--" && resString != "++---") || (results[2] != maxResult && results[3] != maxResult){
            isStrong = false
        }
        
        if isStrong {
            return "Strong"
        }
        else
        {
            return "MiddleWeak"
        }
    }
}

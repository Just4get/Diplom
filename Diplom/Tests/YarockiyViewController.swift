//
//  YarockiyViewController.swift
//  Diplom
//
//  Created by BigDude6 on 27/05/2019.
//  Copyright © 2019 FixXcodeBug. All rights reserved.
//

import UIKit

class YarockiyViewController: UIViewController, Test {
    func launchNextTest() {
        if profession!.testNames.isEmpty {
            let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "ResultsTable") as! ResultTableViewController
            VC1.results = results
            let navController = UINavigationController(rootViewController: VC1) // Creating a navigation controller with VC1 at the root of the navigation stack.
            self.present(navController, animated:true, completion: nil)
            
            /*
            let alert = UIAlertController(title: "Внимание", message: "Все тесты завершены", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)  */
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
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var startTimerButton: UIButton!
    @IBOutlet weak var stopTimerButton: UIButton!
    @IBOutlet weak var restartTimerButton: UIButton!
    var timer = Timer()
    override func viewDidLoad() {
        super.viewDidLoad()
        stopTimerButton.isHidden = true
        startTimerButton.isHidden = false
        restartTimerButton.isHidden = true
        timerLabel.text = "0.00"
        if results == nil {
            results = []
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func startButtonDidPressed(_ sender: UIButton) {
        if timer.isValid {
            timer.invalidate()
            timerLabel.text = "0.00"
        }
        timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(timerUpdate), userInfo: NSDate(), repeats: true)
        startTimerButton.isHidden = true
        stopTimerButton.isHidden = false
        restartTimerButton.isHidden = false
    }
    
    @IBAction func stopButtonDidPressed(_ sender: UIButton) {
        let elapsed = Double(round(-(timer.userInfo as! NSDate).timeIntervalSinceNow*100)/100)
        timer.invalidate()
        startTimerButton.isHidden = false
        stopTimerButton.isHidden = true
        restartTimerButton.isHidden = true
        let result = ResultItem(type: .Yarockiy, time: elapsed, description: "", mistakes: 0)
        results?.append(result)

        launchNextTest()
    }
        
    @objc func timerUpdate(){
        let elapsed = -(timer.userInfo as! NSDate).timeIntervalSinceNow
        timerLabel.text = String(format: "%.2f", elapsed)
    }
    
}

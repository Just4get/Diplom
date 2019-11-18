//
//  NewShulteCollectionViewCell.swift
//  NewShulteGorbov
//
//  Created by BigDude6 on 26/05/2019.
//  Copyright © 2019 BigDude6. All rights reserved.
//

import UIKit

class ShulteViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, Test{
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
    @IBOutlet weak var collectionView: UICollectionView!
    let reuseIdentifier = "cell"
    var buttonsInfo = [GorbovItem]()
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    
    
    @IBAction func skipShulte(_ sender: Any) {
        results?.append(ResultItem(type: .Shulte, time: 0.14, description: "", mistakes: 0))
        launchNextTest()
    }
    var timer = Timer()
    var TestPhase = 0
    var CorrectValue = 1
    var mistakesCount = 0
    var buttonsCount = 25
    var isStarted = false
    var phasesTime:[Double] = [0,0,0,0,0]
    override func viewDidLoad() {
        super.viewDidLoad()
        if results == nil {
            results = []
        }
        initButtons()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return buttonsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        let label = cell.viewWithTag(999) as! UILabel
        
        label.text = "\(buttonsInfo[indexPath.item].value)"
        label.textColor = buttonsInfo[indexPath.item].color
        cell.layer.cornerRadius = 8
        return cell
    }
    
    @IBAction func startButtonDidPressed(_ sender: UIButton) {
        if !isStarted {
            isStarted = true
            sender.setTitle("Рестарт", for: .normal)
        }
        else
        {
            timer.invalidate()
        }
        initButtons()
        collectionView.reloadData()
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(timerUpdate), userInfo: NSDate(), repeats: true)
    }
    
    @objc func timerUpdate(){
        let elapsed = -(timer.userInfo as! NSDate).timeIntervalSinceNow
        timerLabel.text = String(format: "Время: %.1f", elapsed)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isStarted {
            let cell = collectionView.cellForItem(at: indexPath)
            let label = cell?.viewWithTag(999) as! UILabel
            let item = buttonsInfo[indexPath.item]
            
            if item.value == CorrectValue {
                CorrectValue += 1
                highlightPressedItem(ItemRight: true, ItemLabel: label)
                if item.value == 25 {
                    let elapsed = Double(round(-(timer.userInfo as! NSDate).timeIntervalSinceNow*100)/100)
                    timer.invalidate()
                    phasesTime[TestPhase] = elapsed
                    TestPhase += 1
                    
                    if TestPhase == 5 {
                        let effect = phasesTime.reduce(0, +) / Double(phasesTime.count)
                        let resulttime = phasesTime[3] / effect
                        results?.append(ResultItem(type: .Shulte, time: resulttime, description: "", mistakes: 0))
                        launchNextTest()
                    }
                    else
                    {
                        showInfoAlert()
                    }
                }
                
            }
            else
            {
                highlightPressedItem(ItemRight: false, ItemLabel: label)
            }
        }
    }
    
    func initButtons(){
        CorrectValue = 1
        buttonsInfo = [GorbovItem]()
        for i in 1...buttonsCount{
            let buttonInfo = GorbovItem(color: .black, value: i)
            buttonsInfo.append(buttonInfo)
        }
        buttonsInfo.shuffle()
    }
    
    func showInfoAlert(){
        startButton.setTitle("Старт", for: .normal)
        isStarted = false
        let alert = UIAlertController(title: "Тест Шульте", message: "Вы завершили \(TestPhase) этап из 5. Чтобы приступить к следующему этапу нажмите кнопку Старт", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func highlightPressedItem(ItemRight: Bool, ItemLabel: UILabel){
        if ItemRight{
            UIView.animate(withDuration: 1.0){
                ItemLabel.backgroundColor = .clear
                ItemLabel.layer.backgroundColor = UIColor(red:0.45, green:0.99, blue:0.84, alpha:1.0).cgColor
                ItemLabel.layer.backgroundColor = UIColor.white.cgColor
            }
        }
        else
        {
            UIView.animate(withDuration: 1.0){
                ItemLabel.backgroundColor = .clear
                ItemLabel.layer.backgroundColor = UIColor(red:1.00, green:0.10, blue:0.27, alpha:1.0).cgColor
                ItemLabel.layer.backgroundColor = UIColor.white.cgColor
            }
        }
    }

}

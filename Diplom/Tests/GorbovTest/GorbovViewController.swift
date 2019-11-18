//
//  newShulteViewController.swift
//  Diplom
//
//  Created by BigDude6 on 26/05/2019.
//  Copyright © 2019 FixXcodeBug. All rights reserved.
//

import UIKit

class GorbovViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, Test{
    func launchNextTest() {
        if profession!.testNames.isEmpty {
            let alert = UIAlertController(title: "Внимание", message: "Все тесты завершены", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)            
        }
        else {
            let contoller = storyboard?.instantiateViewController(withIdentifier: "TestInfo") as! TestInfoViewController
            contoller.profession = profession
            contoller.results = results
            present(contoller, animated: true, completion: nil)
        }
    }
    
    let reuseIdentifier = "cell"
    var results:[ResultItem]?
    var profession:Profession?
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    
    var buttonsInfo = [GorbovItem]()
    var timer = Timer()
    var isStarted = false
    var CorrectBlackItemValue = 1
    var CorrectRedItemValue = 24
    var isCurrentItemBlack = true
    
    var buttonCounts = 49
    var mistakesCount = [0,0,0]
    var phasesTime:[Double] = [0,0,0]
    var TestPhase = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if results == nil {
            results = []
        }
        initButtons()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return buttonCounts
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        let label = cell.viewWithTag(999) as! UILabel
        
        label.text = "\(buttonsInfo[indexPath.item].value)"
        label.textColor = buttonsInfo[indexPath.item].color
        //cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        return cell
        
    }
    
    func initButtons(){
        buttonsInfo.removeAll()
        for i in 1...buttonCounts/2{
            let redNumber = GorbovItem(color: .red, value: i)
            let blackNumber = GorbovItem(color: .black, value: i)
            buttonsInfo.append(contentsOf: [redNumber,blackNumber])
        }
        
        if (buttonCounts % 2 != 0){
            let redNumber = GorbovItem(color: .black, value: buttonCounts/2 + 1)
            buttonsInfo.append(redNumber)
        }
        buttonsInfo.shuffle()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        let label = cell?.viewWithTag(999) as! UILabel
        
        if isStarted {
            let item = buttonsInfo[indexPath.item]
            if TestPhase == 0 {
                if item.color == UIColor.black && item.value == CorrectBlackItemValue {
                    CorrectBlackItemValue += 1
                    highlightPressedItem(ItemRight: true, ItemLabel: label)
                    
                    // FINISH TEST PHASE 0
                    if item.value == 25 {
                        CorrectBlackItemValue = 1
                        let elapsed = Double(round(-(timer.userInfo as! NSDate).timeIntervalSinceNow*100)/100)
                        timer.invalidate()
                        phasesTime[TestPhase] = elapsed
                        showInfoAlert()
                        return
                    }
                    
                }
                else {
                    mistakesCount[TestPhase] += 1
                    highlightPressedItem(ItemRight: false, ItemLabel: label)
                }

            }
            
            if TestPhase == 1 {
                if item.color == UIColor.red && item.value == CorrectRedItemValue {
                    CorrectRedItemValue -= 1
                    highlightPressedItem(ItemRight: true, ItemLabel: label)
                    
                    // FINISH TEST PHASE 2
                    if item.value == 1 {
                        CorrectRedItemValue = 24
                        let elapsed = Double(round(-(timer.userInfo as! NSDate).timeIntervalSinceNow*100)/100)
                        timer.invalidate()
                        phasesTime[TestPhase] = elapsed
                        showInfoAlert()
                        return
                    }
                }
                else
                {
                    mistakesCount[TestPhase] += 1
                    highlightPressedItem(ItemRight: false, ItemLabel: label)
                }
            }
            
            if TestPhase == 2 {
                if isCurrentItemBlack {
                    if item.color == UIColor.black && item.value == CorrectBlackItemValue {
                        CorrectBlackItemValue += 1
                        highlightPressedItem(ItemRight: true, ItemLabel: label)
                        isCurrentItemBlack = false
                        
                        // FINISH TEST PHASE 3
                        if item.value == 25 {
                            let elapsed = Double(round(-(timer.userInfo as! NSDate).timeIntervalSinceNow*100)/100)
                            timer.invalidate()
                            phasesTime[TestPhase] = elapsed
                            results?.append(calculatedResult())
                            launchNextTest()
                            //performSegue(withIdentifier: "showZIResult", sender: nil)
                        }
                        
                    }
                    else
                    {
                        mistakesCount[TestPhase] += 1
                        highlightPressedItem(ItemRight: false, ItemLabel: label)
                    }
                }
                else
                {
                    if item.color == UIColor.red && item.value == CorrectRedItemValue {
                        CorrectRedItemValue -= 1
                        highlightPressedItem(ItemRight: true, ItemLabel: label)
                        isCurrentItemBlack = true
                    }
                    else
                    {
                        mistakesCount[TestPhase] += 1
                        highlightPressedItem(ItemRight: false, ItemLabel: label)
                    }
                }
            }
        }

        
    }
    
    @IBAction func startButtonDidPressed(_ sender: UIButton) {
        if !isStarted{
            isStarted = true
            sender.setTitle("Рестарт", for: .normal)
        }
        else
        {
            timer.invalidate()
            CorrectBlackItemValue = 1
            CorrectRedItemValue = 24
        }
        initButtons()
        collectionView.reloadData()
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(timerUpdate), userInfo: NSDate(), repeats: true)
    }
    
    @objc func timerUpdate(){
        let elapsed = -(timer.userInfo as! NSDate).timeIntervalSinceNow
        timerLabel.text = String(format: "Время: %.1f", elapsed)
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
    
    func showInfoAlert(){
        startButton.setTitle("Старт", for: .normal)
        isStarted = false
        TestPhase += 1
        let alert = UIAlertController(title: "Тест Горбова", message: "Вы завершили \(TestPhase) этап. Чтобы приступить к следующему этапу нажмите кнопку Старт", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func calculatedResult()->ResultItem  {
        let meanMistake = mistakesCount.reduce(0, +) / mistakesCount.count
        let resultTime = phasesTime[2] - phasesTime[1] - phasesTime[0]
        let result = ResultItem(type: .Gorbov, time: resultTime, description: "", mistakes: meanMistake)
        return result        
    }
    
    @IBAction func skipGorbov(_ sender: UIButton) {
        results?.append(ResultItem(type: .Gorbov, time: 0.14, description: "", mistakes: 0))
        launchNextTest()
    }
}


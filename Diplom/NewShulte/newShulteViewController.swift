//
//  newShulteViewController.swift
//  Diplom
//
//  Created by BigDude6 on 26/05/2019.
//  Copyright © 2019 FixXcodeBug. All rights reserved.
//

import UIKit

class newShulteViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    let reuseIdentifier = "cell"
    var
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) 
        let label = cell.viewWithTag(999) as! UILabel
        label.text = self.items[indexPath.item]
        //cell.backgroundColor = UIColor.cyan // make cell more visible in our example project
        //cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor.red
    }
    
    // change background color back when user releases touch
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor.cyan
    }

    
    @IBOutlet var Buttons: [UIButton]!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    
    var buttonsInfo = [GorbovItem]()
    var ButtonTittles = Array<Int>()
    var timer = Timer()
    var CurrentValue = 0
    var numbersOver = 0 // Количество верно нажатых номеров
    var isStarted = false
    var isLastButtonRed = false
    var buttonCounts = 0
    var mistakesCount = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonCounts = Buttons.count
        ButtonTittles = Array<Int>(repeating: 0, count: buttonCounts)
        startButton.isHidden = false
        stopButton.isHidden = true
        //initButtons()
    }
    
    struct GorbovItem{
        let color:String
        let number:Int
    }
    
    func initButtons(){
        buttonsInfo.removeAll()
        for i in 1...buttonCounts/2{
            let redNumber = GorbovItem(color: "Red", number: i)
            let blackNumber = GorbovItem(color: "Black", number: i)
            buttonsInfo.append(contentsOf: [redNumber,blackNumber])
        }
        if (buttonCounts % 2 != 0){
            let redNumber = GorbovItem(color: "Red", number: buttonCounts)
            buttonsInfo.append(redNumber)
        }
        buttonsInfo.shuffle()
        for i in 0..<buttonCounts{
            Buttons[i].titleLabel?.font = UIFont(name: "Times New Roman", size: 20)
            Buttons[i].setTitle("\(buttonsInfo[i].number)", for: .normal)
            Buttons[i].tag = i
            if buttonsInfo[i].color == "Red"{
                Buttons[i].setTitleColor(.red, for: .normal)
            }
            else
            {
                Buttons[i].setTitleColor(.black, for: .normal)
            }
        }
    }
    
    @IBAction func UIButtonPressed(_ sender: UIButton) {
        if isStarted {
            let buttonsItem = buttonsInfo[sender.tag]
            if isLastButtonRed && CurrentValue == buttonsItem.number &&  buttonsItem.color == "Black"{
                isLastButtonRed = false
                numbersOver += 1
                UIView.animate(withDuration: 1.0){
                    sender.backgroundColor = .clear
                    sender.layer.backgroundColor = UIColor(red:0.45, green:0.99, blue:0.84, alpha:1.0).cgColor
                    sender.layer.backgroundColor = UIColor.white.cgColor
                }
            }
            else
                if isLastButtonRed == false && CurrentValue + 1 == buttonsItem.number && buttonsItem.color == "Red"{
                    CurrentValue += 1
                    numbersOver += 1
                    isLastButtonRed = true
                    UIView.animate(withDuration: 1.0){
                        sender.backgroundColor = .clear
                        sender.layer.backgroundColor = UIColor(red:0.45, green:0.99, blue:0.84, alpha:1.0).cgColor
                        sender.layer.backgroundColor = UIColor.white.cgColor
                    }
                }
                else
                {
                    mistakesCount += 1
                    UIView.animate(withDuration: 1.0){
                        sender.backgroundColor = .clear
                        sender.layer.backgroundColor = UIColor(red:1.00, green:0.10, blue:0.27, alpha:1.0).cgColor
                        sender.layer.backgroundColor = UIColor.white.cgColor
                    }
            }
            if numbersOver == buttonCounts {
                let elapsed = -(timer.userInfo as! NSDate).timeIntervalSinceNow
                timer.invalidate()
                print("Test is done")
                let result = ResultItem(time: elapsed, description: "Описание результата", mistakes: mistakesCount)
                performSegue(withIdentifier: "showResults", sender: result)
            }
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as? ShowResultViewController
        controller?.result = sender as? ResultItem
    }
    
    @IBAction func startButtonDidPressed(_ sender: UIButton) {
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(timerUpdate), userInfo: NSDate(), repeats: true)
        startButton.isHidden = true
        stopButton.isHidden = false
        isStarted = true
        initButtons()
    }
    @objc func timerUpdate(){
        let elapsed = -(timer.userInfo as! NSDate).timeIntervalSinceNow
        timerLabel.text = String(format: "Время: %.1f", elapsed)
    }
    
    @IBAction func stopButtonDidPressed(_ sender: UIButton) {
        timer.invalidate()
        startButton.isHidden = false
        stopButton.isHidden = true
        isStarted = false
        CurrentValue = 0
        mistakesCount = 0
    }
    
    
    
}

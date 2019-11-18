//
//  RavenTestVCCollectionViewController.swift
//  Diplom
//
//  Created by BigDude6 on 12/06/2019.
//  Copyright © 2019 FixXcodeBug. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class RavenTestCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, Test {
    func launchNextTest() {
        if profession!.testNames.isEmpty {
            print("Выбранные тесты закончились")
        }
        else {
            let contoller = storyboard?.instantiateViewController(withIdentifier: "TestInfo") as! TestInfoViewController
            contoller.profession = profession
            contoller.results = results
            present(contoller, animated: true, completion: nil)
        }
    }
    
    var profession: Profession?
    var results: [ResultItem]?
    
    @IBOutlet weak var RavenImageView: UIImageView!
    @IBOutlet weak var RavenAnswerCV: UICollectionView!
    
    var testType:Int = 0
    var testNumber:Int = 0
    var isFinished = false
    var AnswersForTest:[[Int]] = [[4,5,1,2,6,3,6,2,1,3,4,2],
                        [5,6,1,2,1,3,5,6,4,3,4,8],
                        [5,3,2,7,8,4,5,1,7,1,6,2],
                        [3,4,3,8,7,6,5,4,1,2,5,6],
                        [3,4,3,8,7,6,5,4,1,2,5,6]]
    
    var answersCount:[[Int]] = [[6,6,6,6,6,6,6,6,6,6,6,6],
                                 [6,6,6,6,6,6,6,6,6,6,6,8],
                                 [6,8,8,8,8,8,8,8,8,8,8,8],
                                 [8,8,8,8,8,8,8,8,8,8,8,8],
                                 [8,8,8,8,8,8,8,8,8,8,8,8]]
    
    var resultsForTest:[Int] = [0,0,0,0,0,0,0,0,0,55,57,58,59,61,62,65,65,66,67,69,
                                70,71,72,74,75,76,77,79,80,82,83,84,86,87,89,90,91,92,94,95,
                            96,97,99,100,102,104,106,108,110,112,114,116,118,120,122,124,126,128,130,130]
    
    var rightAnswersCount = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        if results == nil {
            results = []
        }
        loadNextLevel()
        // Do any additional setup after loading the view.
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return answersCount[testType][testNumber]
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        let label = cell.viewWithTag(1000) as! UILabel
        
        label.text = "\(indexPath.item + 1)"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isFinished == false {
            //let cell = collectionView.cellForItem(at: indexPath)
            let pressedItemValue = indexPath.item + 1
            if pressedItemValue == AnswersForTest[testType][testNumber] {
                rightAnswersCount += 1
            }
            //print("___ответ: \(pressedItemValue) - \(AnswersForTest[testType][testNumber])")
            testNumber += 1
            if testNumber == 12 && testType == 4 {
                isFinished = true
                showInfoAlert()
            }
            else
            {
                loadNextLevel()
            }
        }
        else{
            showInfoAlert()}
        
    }
    
    func showInfoAlert(){
        let alert = UIAlertController(title: "Тест Равена", message: "Вы завершили Тест. Количество верно решенных заданий: \(rightAnswersCount)", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            UIAlertAction in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "id") as! ResultTableViewController
            vc.results?.append(self.calcResult())
            self.present(vc, animated: true, completion: nil)
        }
        
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func highlightPressedItem(ItemLabel: UILabel){
        UIView.animate(withDuration: 1.0){
            ItemLabel.backgroundColor = .clear
            ItemLabel.layer.backgroundColor = UIColor(red:0.45, green:0.99, blue:0.84, alpha:1.0).cgColor
            ItemLabel.layer.backgroundColor = UIColor.white.cgColor
        }
    }
    
    func loadNextLevel(){
        if testNumber == 12 {
            testNumber = 0
            testType += 1
        }
        var imageName = ""
        switch testType{
        case 0:
            imageName = "A-"
        case 1:
            imageName = "B-"
        case 2:
            imageName = "C-"
        case 3:
            imageName = "D-"
        default:
            imageName = "E-"
        }
        
        imageName += "\(testNumber+1)"
        RavenImageView.image = UIImage(named: imageName)
        RavenAnswerCV.reloadData()
        //print("Данные загружены:", imageName)
    }
    
    func calcResult() -> ResultItem{
        let answersPercent = Double(rightAnswersCount) / 60.0
        var rec = ""
        switch answersPercent
        {
        case 0...5:
            rec = "Дефектная интеллектуальная способность"
        case 6...24:
            rec = "Интеллект ниже среднего"
        case 25...74:
            rec = "Cредний интеллект для данной возрастной группы"
        case 75...95:
            rec = "Незаурядный интеллект для данной возрастной группы"
        case 95...101:
            rec = "Особо высокоразвитый интеллект испытуемого соответствующей возрастной группы"
        default:
            rec = "Дефектная интеллектуальная способность"
        }
        let result = ResultItem(type: .Raven, time: 0, description: rec, mistakes: 60-rightAnswersCount)
        return result
    }
    
    
}

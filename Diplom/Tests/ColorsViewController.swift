//
//  ColorsViewController.swift
//  Diplom
//
//  Created by BigDude6 on 16/05/2019.
//  Copyright © 2019 FixXcodeBug. All rights reserved.
//

import UIKit

class ColorsViewController: UIViewController, Test {
    func launchNextTest() {
        // Если список тестов, которые предстоит решить, пуст то вывод результатов
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
    @IBOutlet weak var timerLabel: UILabel!
    var colors = ["Красный", "Оранжевый", "Желтый", "Зеленый", "Голубой", "Синий","Фиолетовый"]
    var map:[String:UIColor] = [:]
    var isStarted = false
    var currentBgColor = ""
    var mistakesCount = 0
    var testsCount = 10
    var isLastChoiceRight = true
    var rightColors = 0 // количество правильно отгаданных цветов
    @IBOutlet var colorsButtons: [UIButton]!
    override func viewDidLoad() {
        super.viewDidLoad()
        map.updateValue(.red, forKey: "Красный")
        map.updateValue(.blue, forKey: "Синий")
        map.updateValue(.green, forKey: "Зеленый")
        map.updateValue(.purple, forKey: "Фиолетовый")
        map.updateValue(.yellow, forKey: "Желтый")
        map.updateValue(.cyan, forKey: "Голубой")
        map.updateValue(.orange, forKey: "Оранжевый")
        if results == nil {
            results = []
        }
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonDidPressed(_ sender: UIButton) {
        if isStarted {
            if currentBgColor == sender.titleLabel?.text!{
                if isLastChoiceRight {
                    rightColors += 1
                }
                else
                {
                    isLastChoiceRight = true
                }
                timerLabel.text = "Резульатат: \(rightColors)"
                testsCount -= 1
                GenerateNextLevel()
            }
            else
            {
                isLastChoiceRight = false
                rightColors -= 1
                mistakesCount += 1
                timerLabel.text = "Ошибок: \(mistakesCount)"
            }
        }
        else{
            isStarted = true
            timerLabel.text = "Резульатат: 0"
            GenerateNextLevel()
        }
        if testsCount == 0 {
            let result = ResultItem(type: TestTypes.Colors, time: 0, description: "", mistakes: rightColors)
            results?.append(result)
            launchNextTest()
            //performSegue(withIdentifier: "showSIResult", sender: "")
        }
    }
    
    func GenerateNextLevel(){
        var aviableColors = colors
        aviableColors.shuffle()
        currentBgColor = aviableColors[0]
        view.backgroundColor = map[currentBgColor]
        let correctButtonIndex = [0,1,2].randomElement()!
        let randomColor1 = aviableColors[1]
        let randomColor2 = aviableColors[2]
        let randomColor3 = aviableColors[3]

        colorsButtons[correctButtonIndex].setTitle(currentBgColor, for: .normal)
        colorsButtons[correctButtonIndex].setTitleColor(map[randomColor1], for: .normal)
        colorsButtons[(correctButtonIndex + 1) % 3].setTitle(aviableColors[2], for: .normal)
        colorsButtons[(correctButtonIndex + 1) % 3].setTitleColor(map[randomColor2], for: .normal)
        colorsButtons[(correctButtonIndex + 2) % 3].setTitle(aviableColors[3], for: .normal)
        colorsButtons[(correctButtonIndex + 2) % 3].setTitleColor(map[randomColor3], for: .normal)
    }
    
}

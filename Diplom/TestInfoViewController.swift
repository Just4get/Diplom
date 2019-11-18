//
//  TestInfoViewController.swift
//  Diplom
//
//  Created by BigDude6 on 14/06/2019.
//  Copyright © 2019 FixXcodeBug. All rights reserved.
//

import UIKit

class TestInfoViewController: UIViewController, Test {
    
    var descriptions:[TestTypes:String] = [.Ilyin:"Выполнение теста заключается в непрерывном проставлении точек на экране. Необходимо как проставить как можно больше точек за отведенное время. Тест состоит из 6 этапов, каждый этап длится 5 секунд. ",
                                           .Yarockiy:"Для выполнения данного упраженения необходимо совершать непрерывные круговые движения головой в одном направлении (темп выполнения теста 2 оборота за 1 секунду). Длительность выполнения  оперделяется с помощью секундомера. Рекомендуется выполнять упражнение парами: один выполняет, а другой фиксирует время и страхует.",
                                           .Gorbov:"Данный тест является переделанной версией теста Шульте. Тест Горбова состоит из 18 черных и 18 красных чисел. Необходимо найти и выбрать все числа от 1 до 18, при этом чередуя красные и черные числа. Начинать следует с красной 1, затем черная 1 и т.д.",
                                           .Shulte:"Цель теста заключается в последовтельном отыскании всех чисел от 1 до 36 в порядке возрастания. Следует пройти тест, совершая как можно меньше ошибок. Количество ошибок и потраченное время влияют на результаты тестирования.",
                                           .Colors:"В данном тесте вам предстоит внимательно выбирать те кнопки, текст которых соответствует цвету экрана.Постарайтесь совершать как можно меньше ошибок",
                                           .MemoryCard:"Данный тест нацелен для проверки памяти человека. Перед началом все карточки лежат рубашкой вверх. Цель заключается в нахождении всех одинаковых карточек, совершая как можно меньше переворотов карточек.",
                                           .Raven:"Описание теста равена не доступно"]
    
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
    
    @IBOutlet weak var TestNameLabel: UILabel!
    @IBOutlet weak var TestImageView: UIImageView!
    @IBOutlet weak var TestDescriptionTextView: UITextView!
    @IBOutlet weak var TestStartButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let type = (profession?.currentTestName())!
        let name = ResultItem.TestName(type: type)
        let imageName = ResultItem.TestVCID(type: type)
        TestNameLabel.text = name
        
        TestImageView.image = UIImage(named: imageName)
        TestDescriptionTextView.text = descriptions[type]
        TestDescriptionTextView.sizeToFit()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func startButtonDidPressed(_ sender: UIButton) {
        
        let type = (profession?.currentTestName())!
        let vcStoryboardID = ResultItem.TestVCID(type: type)
        
        profession?.removeSolvedTest()
        switch type {
        case .Shulte:
            let controller = storyboard?.instantiateViewController(withIdentifier: vcStoryboardID) as! ShulteViewController
            controller.results = results
            controller.profession = profession
            self.present(controller, animated: true, completion: nil)
        case .Gorbov:
            let controller = storyboard?.instantiateViewController(withIdentifier: vcStoryboardID) as! GorbovViewController
            controller.results = results
            controller.profession = profession
            self.present(controller, animated: true, completion: nil)
        case .Ilyin:
            let controller = storyboard?.instantiateViewController(withIdentifier: vcStoryboardID) as! IlyinTestViewController
            controller.results = results
            controller.profession = profession
            self.present(controller, animated: true, completion: nil)
        case .MemoryCard:
            let controller = storyboard?.instantiateViewController(withIdentifier: vcStoryboardID) as! MemoryCardViewController
            controller.results = results
            controller.profession = profession
            self.present(controller, animated: true, completion: nil)
        case .Colors:
            let controller = storyboard?.instantiateViewController(withIdentifier: vcStoryboardID) as! ColorsViewController
            controller.results = results
            controller.profession = profession
            self.present(controller, animated: true, completion: nil)
        case .Yarockiy:
            let controller = storyboard?.instantiateViewController(withIdentifier: vcStoryboardID) as! YarockiyViewController
            controller.results = results
            controller.profession = profession
            self.present(controller, animated: true, completion: nil)
        case .Raven:
            let controller = storyboard?.instantiateViewController(withIdentifier: vcStoryboardID) as! RavenTestCollectionViewController
            controller.results = results
            controller.profession = profession
            self.present(controller, animated: true, completion: nil)
            
        }
    }
}

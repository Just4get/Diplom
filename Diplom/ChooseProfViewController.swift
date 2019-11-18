//
//  ChooseProfViewController.swift
//  Diplom
//
//  Created by BigDude6 on 28/05/2019.
//  Copyright © 2019 FixXcodeBug. All rights reserved.
//

import UIKit

class ChooseProfViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBAction func unwindToChoosePFK(segue:UIStoryboardSegue) {
    }
    var professions = [Profession]()
    var selectedProfession:Profession?
    @IBOutlet weak var ProfPickerView: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()//[.Ilyin, .Shulte, .Yarockiy, .MemoryCard, .Colors, .Raven]
        professions.append(Profession(name:"Информатика и вычислительная техника", tests: [.Ilyin, .Shulte, .Yarockiy]))
        professions.append(Profession(name:"Информационные системы и технологии", tests: [.Ilyin, .Shulte, .Yarockiy, .MemoryCard, .Gorbov]))
        professions.append(Profession(name:"Прикладная информатика", tests: [.Ilyin, .Shulte, .Yarockiy, .MemoryCard, .Colors]))
        professions.append(Profession(name:"Программная инженерия ", tests: [.Ilyin, .Shulte, .Yarockiy, .Gorbov]))
        
        selectedProfession = professions[0]
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return professions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return professions[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedProfession = professions[row]
    }
    
     @IBAction func startTestButttonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "showPFKList", sender: sender)
     }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let target = segue.destination as? UINavigationController
        let controller = target?.topViewController as? ChosePFKTableViewController
        controller?.profession = selectedProfession
        
    }

}

//
//  ChosePFKTableViewController.swift
//  Diplom
//
//  Created by BigDude6 on 15/06/2019.
//  Copyright © 2019 FixXcodeBug. All rights reserved.
//

import UIKit

class ChosePFKTableViewController: UITableViewController {
    var profession:Profession?
    var checkedPFK:[TestTypes:Bool] = [:]
    var testsCount = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        testsCount = profession!.testNames.count
        print(profession!.testNames)
        for name in profession!.testNames {
            checkedPFK.updateValue(true, forKey: name)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testsCount
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        let name = profession!.testNames[indexPath.item]
        
        if checkedPFK[name] == true {
            cell?.accessoryType = .none
            checkedPFK[name] = false
        }
        else
        {
            cell?.accessoryType = .checkmark
            checkedPFK[name] = true
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = ResultItem.TestName(type: profession!.testNames[indexPath.item])
        return cell
    }


    @IBAction func startDidPressed(_ sender: UIBarButtonItem) {
        let count = checkedPFK.reduce(0, { x, y in x + (y.value ? 1 : 0)})

        if count == 0 {
            let alert = UIAlertController(title: "Ошибка", message: "Не выбран ни один тест (0 из \(testsCount)). Выберите хотябы один.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        }
        else {
            let controller = storyboard?.instantiateViewController(withIdentifier: "TestInfo") as! TestInfoViewController
            let profCopy = profession?.copy() as! Profession
            var testsToSolve = [TestTypes]()
            for test in checkedPFK {
                if test.value {
                    testsToSolve.append(test.key)
                }
            }
            profCopy.testNames = testsToSolve
            controller.profession = profCopy
            print("selected test: ", testsToSolve)
            present(controller, animated: true, completion: nil)
        }
    }
}

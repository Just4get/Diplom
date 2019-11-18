//
//  ResultTableViewController.swift
//  Diplom
//
//  Created by BigDude6 on 29/05/2019.
//  Copyright © 2019 FixXcodeBug. All rights reserved.
//

import UIKit
import CoreData

class ResultTableViewController: UITableViewController{
    var results:[ResultItem]?
    var isDebug = true
    var testNames:[String:String] = ["Ilyin":"Выносливость нервной системы",
                                     "Yarockiy":"Чувствительность вестибулярного аппарата",
                                     "Gorbov":"Переключение внимания",
                                     "Shulte":"Устойчивость внимания",
                                     "MemoryCard":"Память",
                                     "Colors":"Внимательность",
                                     "Raven":"Восприятие форм"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !isDebug {
            save()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results!.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        let label = cell.viewWithTag(2) as! UILabel
        cell.imageView!.image = UIImage(named: "status")
        
        let name = ResultItem.TestName(type: results![indexPath.item].type)
        let testDesciption = name
        label.text = testDesciption
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showResultDetail", sender: results?[indexPath.row])
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showResultDetail"{
            let controller = segue.destination as! ResultViewController
            controller.testResult = (sender as! ResultItem)
        }
    }
    
    func save() {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext

        let entity =
            NSEntityDescription.entity(forEntityName: "TestResult",
                                       in: managedContext)!
        if let results = results {
            for result in results {
    
                let TestResult = NSManagedObject(entity: entity,
                                                 insertInto: managedContext)
                switch result.type {
                case .Colors:
                    TestResult.setValue("Colors", forKey: "testName")
                    TestResult.setValue(result.mistakes, forKey: "mistakes")
                case .Gorbov:
                    TestResult.setValue("Gorbov", forKey: "testName")
                    TestResult.setValue(result.mistakes, forKey: "mistakes")
                    TestResult.setValue(result.time, forKey: "time")
                case .Ilyin:
                    TestResult.setValue("Ilyin", forKey: "testName")
                    TestResult.setValue(result.description, forKey: "descript")
                case .MemoryCard:
                    TestResult.setValue("MemoryCard", forKey: "testName")
                    TestResult.setValue(result.mistakes, forKey: "mistakes")
                case .Shulte:
                    TestResult.setValue("Shulte", forKey: "testName")
                    TestResult.setValue(result.time, forKey: "time")
                case .Yarockiy:
                    TestResult.setValue("Yarockiy", forKey: "testName")
                    TestResult.setValue(result.time, forKey: "time")
                case .Raven:
                    TestResult.setValue("Raven", forKey: "testName")
                    TestResult.setValue(description, forKey: "descript")
                }
                let date = Date()                
                TestResult.setValue(date, forKey: "testDate")

                do {
                    try managedContext.save()
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
            }
        }
    }
}

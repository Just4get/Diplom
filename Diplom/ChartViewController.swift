//
//  ChartViewController.swift
//  Diplom
//
//  Created by BigDude6 on 05/06/2019.
//  Copyright © 2019 FixXcodeBug. All rights reserved.
//

import UIKit
import Charts
import CoreData

class ChartViewController: UIViewController {

    @IBAction func unwindToMainView(segue:UIStoryboardSegue) {
        fetchDate()
        getResultsForAllTests()
    }
    @IBOutlet weak var TopSegmentControl: UISegmentedControl!
    @IBOutlet weak var BottomSegmentControl: UISegmentedControl!
    @IBOutlet weak var ChartVC: BarChartView!
    
    
    var YarockiyResCD = [TestResult]()
    var ShulteResCD = [TestResult]()
    var MemoryCardResCD = [TestResult]()
    var GorbovResCD = [TestResult]()
    var ColorsResCD = [TestResult]()
    
    var DataSetEntry = [BarChartDataEntry]()
    var results: [TestResult]?
    let testNames:[Int:String] = [0: "Yarockiy",
                                  1: "Ilyin",
                                    2: "Shulte",
                                    3: "MemoryCard",
                                    4: "Gorbov",
                                    5: "Colors"]

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchDate()
        getResultsForAllTests()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func ValueChanged(_ sender: UISegmentedControl) {
        var name = ""
        if sender == TopSegmentControl {
            BottomSegmentControl.selectedSegmentIndex = -1
            name = testNames[sender.selectedSegmentIndex]!
        }
        else
        {
            TopSegmentControl.selectedSegmentIndex = -1
            name = testNames[sender.selectedSegmentIndex + 3]!
            
        }
        updateCharts(testName: name)
    }

    func updateCharts(testName:String){
        DataSetEntry.removeAll()
        var position = 1.0
        if testName == "Yarockiy" {
            for result in YarockiyResCD {
                let charData = BarChartDataEntry(x: position, y: result.time)
                DataSetEntry.append(charData)
                position += 1
            }
        }
        
        if testName == "Shulte" {
            for result in ShulteResCD {
                let charData = BarChartDataEntry(x: position, y: result.time)
                DataSetEntry.append(charData)
                position += 1
            }
        }
        
        if testName == "Gorbov" {
            for result in GorbovResCD {
                let charData = BarChartDataEntry(x: position, y: result.time)
                DataSetEntry.append(charData)
                position += 1
            }
        }
        
        if testName == "MemoryCard" {
            for result in MemoryCardResCD {
                let charData = BarChartDataEntry(x: position, y: Double(result.mistakes))
                DataSetEntry.append(charData)
                position += 1
            }
        }
        
        if testName == "Colors" {
            for result in ColorsResCD {
                let charData = BarChartDataEntry(x: position, y: Double(result.mistakes))
                DataSetEntry.append(charData)
                position += 1
            }
        }
        
        let chartDataSet = BarChartDataSet(entries: DataSetEntry, label: testName)
        
        chartDataSet.colors = [#colorLiteral(red: 0.9176470588, green: 0.2784313725, blue: 0.4117647059, alpha: 1)]
        let dataSets: [BarChartDataSet] = [chartDataSet]
        let chartData = BarChartData(dataSets: dataSets)
        ChartVC.data = chartData
    }
    
    
    func getResultsForAllTests(){
        if let results = results {
            for res in results {
                let testName = res.testName!
                
                switch testName{
                case "Yarockiy":
                    YarockiyResCD.append(res)
                case "Shulte" :
                    ShulteResCD.append(res)
                case "MemoryCard":
                    MemoryCardResCD.append(res)
                case "Gorbov":
                    GorbovResCD.append(res)
                case "Colors":
                    ColorsResCD.append(res)
                default:
                    print(testName," will not show")
                }
            }
        }
    }
    
    func fetchDate(){
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "TestResult")

        do {
            results = try managedContext.fetch(fetchRequest) as? [TestResult]
            if let results = results {
                for data in results{
                    print(data.testName!)
                    print(data.time)
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

}

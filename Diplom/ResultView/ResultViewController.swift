//
//  ShowResultViewController.swift
//  Diplom
//
//  Created by BigDude6 on 08/05/2019.
//  Copyright © 2019 FixXcodeBug. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    var testResult:ResultItem?
    var profession:Profession?
    
    @IBOutlet weak var testNameLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        testNameLabel.text = ResultItem.TestName(type: testResult!.type)
        descriptionTextView.text = testResult?.Recommendation
        descriptionTextView.sizeToFit()
    }
    
}

//
//  TestResult+CoreDataProperties.swift
//  Diplom
//
//  Created by BigDude6 on 06/06/2019.
//  Copyright © 2019 FixXcodeBug. All rights reserved.
//
//

import Foundation
import CoreData


extension TestResult {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TestResult> {
        return NSFetchRequest<TestResult>(entityName: "TestResult")
    }

    @NSManaged public var descript: String?
    @NSManaged public var mistakes: Int32
    @NSManaged public var testDate: NSDate?
    @NSManaged public var testName: String?
    @NSManaged public var time: Double

}

//
//  Proffession.swift
//  Diplom
//
//  Created by BigDude6 on 28/05/2019.
//  Copyright © 2019 FixXcodeBug. All rights reserved.
//

import Foundation
class Profession {
    let name:String
    var testNames:[TestTypes]
    init(name:String, tests:[TestTypes]) {
        self.name = name
        self.testNames = tests
    }
    
    func removeSolvedTest(){
        testNames.removeFirst()
    }
    
    func currentTestName() -> TestTypes {
        return testNames[0]
    }
    
    func copy() -> Any {
        let copy = Profession(name: name, tests: testNames)
        return copy
    }
    
}
enum TestTypes {
    case Colors
    case Gorbov
    case Ilyin
    case MemoryCard
    case Raven
    case Shulte
    case Yarockiy
}

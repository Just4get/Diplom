//
//  TestProtocol.swift
//  Diplom
//
//  Created by BigDude6 on 14/06/2019.
//  Copyright © 2019 FixXcodeBug. All rights reserved.
//

import Foundation

protocol Test {
    var profession:Profession? {
        get set        
    }
    
    var results:[ResultItem]? {get set}
    func launchNextTest()
}

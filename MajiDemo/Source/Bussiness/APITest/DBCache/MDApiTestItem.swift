//
//  MDApiTestItem.swift
//  MajiDemo
//
//  Created by dbloong on 2020/9/1.
//  Copyright © 2020 dull-brain. All rights reserved.
//

import UIKit

class MDApiTestItem: NSObject {
    
    var entityId: Int = -1
    var time: Date?
    var data: [String: Any]?
    
    override init() {
        super.init()
    }
    
    init(eId: Int, time: Date, data: [String: Any]) {
        self.entityId = eId
        self.time = time
        self.data = data
        super.init()
    }
}

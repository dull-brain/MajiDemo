//
//  MDApiTestItem.swift
//  MajiDemo
//
//  Created by dbloong on 2020/9/1.
//  Copyright © 2020 dull-brain. All rights reserved.
//

import UIKit

class MDApiTestItem: NSObject {
    
    var entityId: Int = -1;
    var time: Date?
    var data: Dictionary<String, Any>?
    
    init(eId: Int, time: Date, data: Dictionary<String, Any>) {
        self.entityId = eId
        self.time = time
        self.data = data
        super.init()
    }
}

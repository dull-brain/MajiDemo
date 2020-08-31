//
//  MDApiTestDBCache.swift
//  MajiDemo
//
//  Created by dbloong on 2020/9/1.
//  Copyright © 2020 dull-brain. All rights reserved.
//

import UIKit

class MDApiTestDBCache: NSObject {
    
    static var hasTable: Bool = false
    
    class func tableExist() -> Bool {
        if (self.hasTable == false) {
            //实际判断数据库是否存在表，弱不存在则创建
            
        }
        return self.hasTable;
    }
    
    class func addRequest(item: MDApiTestItem) -> Void {
        if (self.tableExist()) {
            
        }
    }
    
    class func addRequest(items: [MDApiTestItem]) -> Void {
        if (self.tableExist()) {
            
        }
    }
    
    class func query(groupSize: Int, groupIndex: Int, ascending: Bool, resultBlock: (_ result: [MDApiTestItem]) -> Void) -> Void {
        if (self.tableExist()) {
            
        }
    }
}

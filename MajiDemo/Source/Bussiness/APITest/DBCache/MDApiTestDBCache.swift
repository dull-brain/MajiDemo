//
//  MDApiTestDBCache.swift
//  MajiDemo
//
//  Created by dbloong on 2020/9/1.
//  Copyright © 2020 dull-brain. All rights reserved.
//

import UIKit

let NOTIFICATION_TEST_REQUEST_ADD: String = "notification_home_request_add"

class MDApiTestDBCache: NSObject {
    
    static var hasTable: Bool = false
    
    class func tableExist() -> Bool {
        if (self.hasTable == false) {
            //实际判断数据库是否存在表，若不存在则创建
            let db = FMDatabase.init(path: MDDatabaseManager.sharedManager.databaseFilePath)
            db.open()
            let sql = "SELECT COUNT(*) count FROM sqlite_master where type='table' and name='Home_Request'"
            let rs = db.executeQuery(sql, withArgumentsIn: [])
            if let rst = rs {
                let count: Int = NSDecimalNumber(string: rst.string(forColumn: "count")).intValue
                if (count == 1) {
                    //实际存在
                    self.hasTable = true
                }
            }
            if (self.hasTable == false) {
                //实际不存在，建表
                let  tbCrt = """
                CREATE TABLE IF NOT EXISTS Home_Request \
                (id INTEGER PRIMARY KEY AUTOINCREMENT, \
                sdate TEXT, result TEXT);
                """
                db.executeUpdate(tbCrt, withArgumentsIn: [])
                self.hasTable = true
            }
            db.close()
        }
        return self.hasTable
    }
    
    class func addRequest(item: MDApiTestItem) -> Void {
        if (self.tableExist()) {
            if (self.tableExist()) {
                if let time = item.time, let dic = item.data {
                    let dateStr = String(format: "%lf", time.timeIntervalSince1970)
                    let data = try? JSONSerialization.data(withJSONObject: dic, options: .fragmentsAllowed)
                    let sql = "INSERT INTO Home_Request (sdate, result) VALUES('" + dateStr + "', ?);"
                    if let dt = data {
                        FMDatabaseQueue
                            .init(path: MDDatabaseManager.sharedManager.databaseFilePath as String)?
                            .inDatabase({ (database) in
                                database.executeUpdate(sql, withArgumentsIn: [dt])
                                DispatchQueue.main.async {
                                    NotificationCenter.default.post(
                                        name: NSNotification.Name(NOTIFICATION_TEST_REQUEST_ADD),
                                    object: nil)
                                    
                                }
                        })
                    }
                }
            }
        }
    }
    
    class func addRequest(items: [MDApiTestItem]) -> Void {
        if (self.tableExist()) {
            
        }
    }
    
    class func query(groupSize: Int,
                     groupIndex: Int,
                     ascending: Bool,
                     resultBlock: (_ result: [MDApiTestItem]) -> Void) -> Void {
        if (self.tableExist()) {
            let ot = ascending ? "ASC" : "DESC"
            let sql = "SELECT * FROM Home_Request ORDER BY id \(ot) LIMIT \(groupIndex), \(groupSize)"
            FMDatabaseQueue.init(path: MDDatabaseManager.sharedManager.databaseFilePath as String)?
                .inDatabase({ (database) in
                let rst = try? database.executeQuery(sql, values: nil)
                var array = [MDApiTestItem]()
                if let rs = rst {
                    while (rs.next()) {
                        let eid = Int(rs.string(forColumn: "id")!)!
                        let dateStr: String = rs.string(forColumn: "sdate")!
                        let dataRs = rs.data(forColumn: "result")!
                        let rsDic = try? JSONSerialization.jsonObject(with: dataRs, options: .fragmentsAllowed)
                        let interval: TimeInterval = NumberFormatter().number(from: dateStr)!.doubleValue
                        let date = Date.init(timeIntervalSince1970: interval)
                        if let dtDic = rsDic {
                            let item = MDApiTestItem(eId: eid, time: date, data: dtDic as! [String : Any])
                            array.append(item)
                        }
                    }
                } else {
                    
                }
                resultBlock(array)
            })
        }
    }
}

//
//  MDDatabaseManager.swift
//  MajiDemo
//
//  Created by dbloong on 2020/9/1.
//  Copyright © 2020 dull-brain. All rights reserved.
//

import UIKit

class MDDatabaseManager: NSObject {
    
    static var sharedManager = MDDatabaseManager()
    var databaseFilePath: String
    
    private override init() {
        databaseFilePath = ""
        super.init()
        self.databaseInit()
    }
    
    private func databaseInit() {
        let dir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let filePath = String.init(format: "%@/database.db", dir)
        self.databaseFilePath = filePath
        if (FileManager.default.fileExists(atPath: self.databaseFilePath) == false) {
            FileManager.default.createFile(atPath: self.databaseFilePath, contents: nil, attributes: nil)
        }
    }
}

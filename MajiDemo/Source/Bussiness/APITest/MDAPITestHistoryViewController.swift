//
//  MDAPITestHistoryViewController.swift
//  MajiDemo
//
//  Created by dbloong on 2020/9/1.
//  Copyright © 2020 dull-brain. All rights reserved.
//

import UIKit

class MDAPITestHistoryViewController: MDBaseViewController, UITableViewDelegate, UITableViewDataSource {

    var tableView: UITableView?
    
    var dataArray: [MDApiTestItem] = [MDApiTestItem]()
    var cellHMap: [Int: CGFloat] = [Int: CGFloat]()
    var foldMap: [Int: String] = [Int: String]()
    var dateFmt: DateFormatter?
    
    var pageSize = 20
    var pageIndex: Int {
        let sz = (pageSize > 0 ? pageSize : 1)
        return self.dataArray.count / sz + 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "API访问历史"
        
        self.tableView = UITableView.init(frame: self.view.bounds)
        self.tableView!.delegate = self
        self.tableView!.dataSource = self
        self.tableView!.tableFooterView = UIView()
        self.tableView!.register(MDApiTestHistoryCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(self.tableView!)
        
        self.dateFmt = DateFormatter.init()
        self.dateFmt?.timeZone = TimeZone.current
        self.dateFmt?.dateFormat = "YYYY-MM-dd HH:mm:ss"
        
        weak var weakSelf = self
        
        self.tableView?.mj_header = MJRefreshHeader(refreshingBlock: {
            weakSelf?.reloadData()
        })
        
        self.tableView?.mj_footer = MJRefreshBackFooter(refreshingBlock: {
            weakSelf?.loadMoreData()
        })
        
        self.reloadData()
        
        _ = NotificationCenter.default.rx.notification(Notification.Name(NOTIFICATION_TEST_REQUEST_ADD))
            .takeUntil(self.rx.deallocated)
            .subscribe(onNext: { (notification) in
                if (notification.name.rawValue == NOTIFICATION_TEST_REQUEST_ADD) {
                    self.reloadAdded()
                }
            })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        let data = self.dataArray[indexPath.row]
        cell.textLabel?.text = self.dateFmt?.string(from: data.time!)
        cell.detailTextLabel?.text = data.data?.description
        (cell as! MDApiTestHistoryCell).stateLab?.text = self.foldMap[data.entityId] == nil ? "v" : "<"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let data = self.dataArray[indexPath.row]
        if nil != self.foldMap[data.entityId] {
            self.foldMap.removeValue(forKey: data.entityId)
        } else {
            self.foldMap[data.entityId] = "fd"
        }
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: .none)
        tableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let data = self.dataArray[indexPath.row]
        if nil != self.foldMap[data.entityId] {
            return 80
        } else {
            if let h = self.cellHMap[data.entityId] {
                return h
            } else {
                return 80
            }
        }
    }
    
    func reloadData() -> Void {
        let cellW = self.tableView!.frame.size.width
        DispatchQueue.global().async {
            MDApiTestDBCache.query(groupSize: self.pageSize, groupIndex: 0, ascending: false) { (array) in
                array.forEach { (item) in
                    if let edic = item.data {
                        let text = edic.description
                        let oh = self.cellHMap[item.entityId]
                        if nil == oh {
                            self.cellHMap[item.entityId] = MDApiTestHistoryCell.cellHeight(text: text, width: cellW)
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.dataArray = array
                    self.tableView?.reloadData()
                    self.tableView?.mj_header.endRefreshing()
                }
            }
        }
    }
    
    func loadMoreData() -> Void {
        let cellW = self.tableView!.frame.size.width
        DispatchQueue.global().async {
            MDApiTestDBCache.query(groupSize: self.pageSize, groupIndex: self.pageIndex, ascending: false) { (array) in
                var arr = [MDApiTestItem]()
                self.dataArray.forEach { (item) in
                    arr.append(item)
                }
                var rows = [IndexPath]()
                var i = 0
                array.forEach { (item) in
                    if let edic = item.data {
                        let text = edic.description
                        let oh = self.cellHMap[item.entityId]
                        if nil == oh {
                            self.cellHMap[item.entityId] = MDApiTestHistoryCell.cellHeight(text: text, width: cellW)
                            arr.append(item)
                            rows.append(IndexPath.init(row: i, section: 0))
                            i += 1
                        }
                    }
                }
                if rows.count >= 1 {
                    DispatchQueue.main.async {
                        self.tableView?.beginUpdates()
                        self.dataArray = arr
                        self.tableView?.insertRows(at: rows, with: .none)
                        self.tableView?.endUpdates()
                        self.tableView?.mj_footer.endRefreshing()
                    }
                }
            }
        }
    }
    
    func reloadAdded() -> Void {
        let cellW = self.tableView!.frame.size.width
        DispatchQueue.global().async {
            MDApiTestDBCache.query(groupSize: self.pageSize, groupIndex: 0, ascending: false) { (array) in
                var map = [Int: Any]()
                var arr = [MDApiTestItem]()
                self.dataArray.forEach { (item) in
                    map[item.entityId] = item
                    arr.append(item)
                }
                var rows = [IndexPath]()
                var i = 0
                array.reversed().forEach { (item) in
                    let oitem = map[item.entityId]
                    if nil == oitem {
                        self.cellHMap[item.entityId] = MDApiTestHistoryCell.cellHeight(
                            text: item.data?.description,
                            width: cellW)
                        arr.insert(item, at: 0)
                        rows.append(IndexPath.init(row: i, section: 0))
                        self.foldMap[item.entityId] = "fd"
                        i += 1
                    }
                }
                DispatchQueue.main.async {
                    self.tableView?.beginUpdates()
                    self.dataArray = arr
                    self.tableView?.insertRows(at: rows, with: .none)
                    self.tableView?.endUpdates()
                }
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

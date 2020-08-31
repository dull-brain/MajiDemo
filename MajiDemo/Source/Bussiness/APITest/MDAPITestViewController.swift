//
//  MDAPITestViewController.swift
//  MajiDemo
//
//  Created by dbloong on 2020/9/1.
//  Copyright © 2020 dull-brain. All rights reserved.
//

import UIKit

class MDAPITestViewController: MDBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "API访问"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "历史", style: .plain, target: self, action: #selector(showHistory))
    }
    
    @objc func showHistory() -> Void {
        self.navigationController?.pushViewController(MDAPITestHistoryViewController(), animated: true)
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

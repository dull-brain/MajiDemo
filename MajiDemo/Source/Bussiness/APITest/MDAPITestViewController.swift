//
//  MDAPITestViewController.swift
//  MajiDemo
//
//  Created by dbloong on 2020/9/1.
//  Copyright © 2020 dull-brain. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MDAPITestViewController: MDBaseViewController {

    var scrollView: UIScrollView?
    var dataLabel: UILabel?

    var reloadTimer: Timer?
    var disposeBag = DisposeBag()
    @objc dynamic var dataStr: String?
    
    var apiTask: URLSessionDataTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "API访问"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(
            title: "历史",
            style: .plain,
            target: self,
            action: #selector(showHistory))

        self.scrollView = UIScrollView()
        self.dataLabel = UILabel()
        
        self.dataLabel!.textColor = UIColor.black
        self.dataLabel!.font = UIFont.boldSystemFont(ofSize: 20)
        self.dataLabel!.numberOfLines = 0
        
        self.view.addSubview(self.scrollView!)
        self.scrollView!.addSubview(self.dataLabel!)
        
        self.rx.observeWeakly(String.self, "dataStr")
        .subscribe(onNext: {[weak self] (text) in
            DispatchQueue.main.async {
                self?.dataLabel?.text = self?.dataStr
                self?.relayout()
            }
        })
        .disposed(by: disposeBag)
        
        DispatchQueue.global().async {
            MDApiTestDBCache.query(groupSize: 1, groupIndex: 0, ascending: false) { (array) in
                if let data: MDApiTestItem = array.first {
                    self.dataStr = data.data?.description
                }
            }
        }
        
        weak var weakSelf = self
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { (timer) in
            weakSelf?.reloadData()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self .relayout()
    }
    
    @objc func showHistory() -> Void {
        self.navigationController?.pushViewController(MDAPITestHistoryViewController(), animated: true)
    }
    
    func relayout() {
        self.scrollView?.frame = self.view.frame
        let textSize = self.dataLabel?.sizeThatFits(
            CGSize(
            width: self.view.frame.size.width - 20,
            height: CGFloat.greatestFiniteMagnitude))
        self.dataLabel?.frame = CGRect(
        x: 10,
        y: 10,
        width: self.view.frame.size.width - 20,
        height: textSize!.height)
        self.scrollView!.contentSize = CGSize(
            width: self.view.frame.size.width,
            height: (self.dataLabel?.frame.size.height)! + 20)
    }
    
    func reloadData() {
        if (self.apiTask == nil) {
            weak var weakSelf = self
            self.apiTask = URLSession.shared
                .dataTask(with: URL.init(string: "https://api.github.com")!) {(data, response, error) in
                    if (error == nil) {
                        let dict = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                        if let dic = dict {
                            DispatchQueue.global().async {
                                let item = MDApiTestItem()
                                item.data = dic as? [String: Any]
                                item.time = Date()
                                MDApiTestDBCache.addRequest(item: item)
                                self.dataStr = item.data?.description
                            }
                        }
                    } else {
                        
                    }
                    weakSelf?.apiTask = nil
            }
            self.apiTask?.resume()
        }
    }
    /*
    func testData() -> [String: String] {
        return [
          "current_user_url": "https://api.github.com/user",
          "current_user_authorizations_html_url": "https://github.com/settings/connections/applications{/client_id}",
          "authorizations_url": "https://api.github.com/authorizations",
          "code_search_url": "https://api.github.com/search/code?q={query}{&page,per_page,sort,order}",
          "commit_search_url": "https://api.github.com/search/commits?q={query}{&page,per_page,sort,order}",
          "emails_url": "https://api.github.com/user/emails",
          "emojis_url": "https://api.github.com/emojis",
          "events_url": "https://api.github.com/events",
          "feeds_url": "https://api.github.com/feeds",
          "followers_url": "https://api.github.com/user/followers",
          "following_url": "https://api.github.com/user/following{/target}",
          "gists_url": "https://api.github.com/gists{/gist_id}",
          "hub_url": "https://api.github.com/hub",
          "issue_search_url": "https://api.github.com/search/issues?q={query}{&page,per_page,sort,order}",
          "issues_url": "https://api.github.com/issues",
          "keys_url": "https://api.github.com/user/keys",
          "label_search_url": "https://api.github.com/search/labels?q={query}&repository_id={repository_id}{&page,per_page}",
          "notifications_url": "https://api.github.com/notifications",
          "organization_url": "https://api.github.com/orgs/{org}",
          "organization_repositories_url": "https://api.github.com/orgs/{org}/repos{?type,page,per_page,sort}",
          "organization_teams_url": "https://api.github.com/orgs/{org}/teams",
          "public_gists_url": "https://api.github.com/gists/public",
          "rate_limit_url": "https://api.github.com/rate_limit",
          "repository_url": "https://api.github.com/repos/{owner}/{repo}",
          "repository_search_url": "https://api.github.com/search/repositories?q={query}{&page,per_page,sort,order}",
          "current_user_repositories_url": "https://api.github.com/user/repos{?type,page,per_page,sort}",
          "starred_url": "https://api.github.com/user/starred{/owner}{/repo}",
          "starred_gists_url": "https://api.github.com/gists/starred",
          "user_url": "https://api.github.com/users/{user}",
          "user_organizations_url": "https://api.github.com/user/orgs",
          "user_repositories_url": "https://api.github.com/users/{user}/repos{?type,page,per_page,sort}",
          "user_search_url": "https://api.github.com/search/users?q={query}{&page,per_page,sort,order}"
        ]
    }
 */
    
    deinit {
        self.reloadTimer?.invalidate()
        self.apiTask?.cancel()
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

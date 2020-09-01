//
//  MDApiTestHistoryCell.swift
//  MajiDemo
//
//  Created by dbloong on 2020/9/1.
//  Copyright © 2020 dull-brain. All rights reserved.
//

import UIKit

class MDApiTestHistoryCell: UITableViewCell {
    
    let stateLab: UILabel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.stateLab = UILabel.init()
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        self.textLabel?.font = UIFont.systemFont(ofSize: 16)
        self.detailTextLabel?.font = UIFont.systemFont(ofSize: 14)
        self.detailTextLabel?.numberOfLines = 0
        self.stateLab!.font = UIFont.boldSystemFont(ofSize: 16)
        self.stateLab!.textAlignment = NSTextAlignment.right
        self.contentView.addSubview(self.stateLab!)
    }
    
    required init?(coder: NSCoder) {
        self.stateLab = nil
        super.init(coder: coder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.stateLab?.frame = CGRect(x:self.frame.size.width - 30 - 10, y: 0, width: 30, height: 30)
        self.textLabel?.frame = CGRect(x: 10, y: 0, width: (self.stateLab?.frame.origin.x)! - 10, height: 30)
        self.detailTextLabel?.frame = CGRect(
            x: 10,
            y: 30,
            width: self.frame.size.width - 20,
            height: self.frame.size.height - 30 - 10)
    }
    
    class func cellHeight(text: String?, width: CGFloat) -> CGFloat {
        if let t = text {
            let h = t.boundingRect(
                with: CGSize(width: width - 20, height: CGFloat.greatestFiniteMagnitude),
                options: .usesLineFragmentOrigin,
                attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)],
                context: nil).size.height + 40
            return h
        }
        return 0
    }

}

//
//  MangaItemCell.swift
//  Zang
//
//  Created by drskur on 2017. 12. 4..
//  Copyright © 2017년 drskur. All rights reserved.
//

import UIKit

class MangaItemCell: UITableViewCell {
    
    @IBOutlet weak var mangaNameLabel: UILabel!
    var readIcon: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        readIcon = UIView(frame: CGRect(x: 0, y: 0, width: 6, height: 6))
        readIcon.center = CGPoint(x: 10, y: self.center.y)
        readIcon.backgroundColor = UIColor.blue
        readIcon.layer.cornerRadius = 3
        readIcon.isHidden = true
        readIcon.layer.borderColor = UIColor.black.cgColor
        readIcon.layer.borderWidth = 0
        self.addSubview(readIcon)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setRead(_ read: Bool) {
        readIcon.isHidden = !read
    }
    
    func setFinish(_ finish: Bool) {
        if (finish) {
            readIcon.backgroundColor = UIColor.clear
            readIcon.layer.borderWidth = 1.0
        } else {
            readIcon.backgroundColor = UIColor.blue
            readIcon.layer.borderWidth = 0.0
        }
    }
    
}
